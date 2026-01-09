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

    final batteryLvl = await battery.batteryLevel;
    final batterySt = await battery.batteryState;
    final android = await deviceInfo.androidInfo;
    final conn = await connectivity.checkConnectivity();
    final cpu = await CpuService.getCpuUsage();

    setState(() {
      batteryLevel = batteryLvl;
      batteryState = batterySt.toString().split('.').last;
      deviceModel = android.model;
      androidVersion = android.version.release;
      network = conn.name;
      cpuUsage = cpu;
      totalRam = SysInfo.getTotalPhysicalMemory() ~/ (1024 * 1024);
      freeRam = SysInfo.getFreePhysicalMemory() ~/ (1024 * 1024);
    });
  }

  Widget infoCard(String title, String value) {
    return Card(
      child: ListTile(title: Text(title), trailing: Text(value)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Monitor')),
      body: RefreshIndicator(
        onRefresh: loadData,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            infoCard("Device", deviceModel),
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
