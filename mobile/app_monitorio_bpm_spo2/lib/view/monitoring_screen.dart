import 'dart:async';
import 'dart:math';

import 'package:app_monitorio_bpm_spo2/mqtt/mqtt_manager.dart';
import 'package:app_monitorio_bpm_spo2/mqtt/state/mqtt_app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MonitoringScreenState();
  }
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  double oxygenSaturation = 0.0;
  double heartRate = 0.0;
  Timer? _timer;
  late MQTTAppState currentAppState;
  late MQTTManager manager;

  @override
  void initState() {
    super.initState();
    // Simular actualización de datos cada segundo
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        oxygenSaturation = Random().nextInt(20) +
            80.0; // Simulación de datos de saturación de oxígeno
        heartRate = Random().nextInt(40) +
            60.0; // Simulación de datos de frecuencia cardíaca
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    currentAppState = appState;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oxygen Saturation Monitor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              'Saturación de Oxígeno: ${oxygenSaturation.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              'Frecuencia Cardíaca: ${heartRate.toStringAsFixed(1)} bpm',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 40),
            // Aquí puedes agregar gráficos animados, botones interactivos, etc.
            // Por ejemplo, podrías usar gráficos animados de la biblioteca 'fl_chart'.
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón
              },
              child: const Text('Iniciar Medición'),
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildConnectButtonFrom(MQTTAppConnectionState state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
            ),
            onPressed: state == MQTTAppConnectionState.disconnected
                ? _configureAndConnect
                : null,
            child: const Text('Connect'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed:
                state == MQTTAppConnectionState.connected ? _disconnect : null,
            child: const Text('Disconnect'),
          ),
        ),
      ],
    );
  }
}
