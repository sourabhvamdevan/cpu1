import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:system_info2/system_info2.dart';

import 'services/cpu_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int batteryLevel = 0;
  String batteryState = '';
  String deviceModel = '';
  String androidVersion = '';
  String network = '';
  double cpuUsage = 0.0;
  int totalRam = 0;
  int freeRam = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final battery = Battery();
    final deviceInfo = DeviceInfoPlugin();
    final connectivity = Connectivity();

    final int batteryLvl = await battery.batteryLevel;
    final BatteryState batterySt = await battery.batteryState;
    final android = await deviceInfo.androidInfo;

    final List<ConnectivityResult> conn = await connectivity
        .checkConnectivity();

    final double cpu = await CpuService.getCpuUsage();

    String networkStatus;
    if (conn.contains(ConnectivityResult.wifi)) {
      networkStatus = "WiFi";
    } else if (conn.contains(ConnectivityResult.mobile)) {
      networkStatus = "Mobile Data";
    } else if (conn.contains(ConnectivityResult.ethernet)) {
      networkStatus = "Ethernet";
    } else {
      networkStatus = "No Network";
    }

    setState(() {
      batteryLevel = batteryLvl;
      batteryState = batterySt.toString().split('.').last;
      deviceModel = android.model;
      androidVersion = android.version.release;
      network = networkStatus;
      cpuUsage = cpu;
      totalRam = SysInfo.getTotalPhysicalMemory() ~/ (1024 * 1024);
      freeRam = SysInfo.getFreePhysicalMemory() ~/ (1024 * 1024);
    });
  }

  Widget infoCard(String title, String value) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Monitor'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: loadData,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            infoCard("Device Model", deviceModel),
            infoCard("Android Version", androidVersion),
            infoCard("Battery Level", "$batteryLevel%"),
            infoCard("Battery Status", batteryState),
            infoCard("Network", network),
            infoCard("CPU Usage", "${cpuUsage.toStringAsFixed(2)}%"),
            infoCard("Total RAM", "$totalRam MB"),
            infoCard("Free RAM", "$freeRam MB"),
          ],
        ),
      ),
    );
  }
}
