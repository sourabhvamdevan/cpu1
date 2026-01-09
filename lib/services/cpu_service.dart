import 'package:flutter/services.dart';

class CpuService {
  static const MethodChannel _channel = MethodChannel('device.monitor/cpu');

  static Future<double> getCpuUsage() async {
    try {
      final result = await _channel.invokeMethod<double>('getCpuUsage');
      return result ?? 0.0;
    } catch (_) {
      return 0.0;
    }
  }
}
