package com.example.cpu_demo

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.RandomAccessFile

class MainActivity : FlutterActivity() {

    private val CHANNEL = "device.monitor/cpu"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getCpuUsage") {
                    result.success(readCpuUsage())
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun readCpuUsage(): Double {
        return try {
            val reader = RandomAccessFile("/proc/stat", "r")
            val line = reader.readLine()
            reader.close()

            val toks = line.split("\\s+".toRegex())
            if (toks.size < 5) return 0.0

            val idle = toks[4].toLongOrNull() ?: 0L
            var total = 0L
            for (i in 1 until toks.size) {
                total += toks[i].toLongOrNull() ?: 0L
            }

            if (total == 0L) return 0.0
            ((total - idle) * 100.0) / total
        } catch (e: Exception) {
            0.0
        }
    }
}



