import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const DeviceMonitorApp());
}

class DeviceMonitorApp extends StatelessWidget {
  const DeviceMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
