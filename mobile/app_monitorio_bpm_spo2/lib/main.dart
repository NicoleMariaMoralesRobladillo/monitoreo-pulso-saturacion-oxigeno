import 'package:app_monitorio_bpm_spo2/view/monitoring_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oxygen Saturation Monitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MonitoringScreen(),
    );
  }
}
