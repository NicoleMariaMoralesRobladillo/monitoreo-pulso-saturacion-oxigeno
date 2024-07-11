import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:mqtt_app_client/model/measure.dart';
import 'package:mqtt_app_client/mqtt/mqtt_manager.dart';
import 'package:mqtt_app_client/mqtt/state/mqtt_app_state.dart';
import 'package:provider/provider.dart';

class MQTTView extends StatefulWidget {
  const MQTTView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MQTTViewState();
  }
}

class _MQTTViewState extends State<MQTTView> {
  final TextEditingController _hostTextController = TextEditingController();
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();
  late MQTTAppState currentAppState;
  late MQTTManager manager;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _hostTextController.dispose();
    _messageTextController.dispose();
    _topicTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    currentAppState = appState;
    final Scaffold scaffold = Scaffold(body: _buildColumn());
    return scaffold;
  }

  Widget _buildColumn() {
    return Column(
      children: <Widget>[
        _buildConnectionStateText(
            _prepareStateMessageFrom(currentAppState.getAppConnectionState)),
        _buildEditableColumn(),
        _buildMeasure(currentAppState.getReceivedText)
      ],
    );
  }

  Widget _buildEditableColumn() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildConnectButtonFrom(currentAppState.getAppConnectionState)
        ],
      ),
    );
  }

  Widget _buildConnectionStateText(String status) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              color: Colors.deepOrangeAccent,
              child: Text(status, textAlign: TextAlign.center)),
        ),
      ],
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
            child: const Text('Conectar'),
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
            child: const Text('Desconectar'),
          ),
        ),
      ],
    );
  }

  Widget _buildMeasure(String text) {
    Map<String, dynamic> measureJson = jsonDecode(text);
    Measure measure = Measure.fromJson(measureJson);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          Text(
            'Saturación de Oxígeno: ${measure.spo2Rate}%',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          Text(
            'Frecuencia Cardíaca: ${measure.heartRate} bpm',
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }

  String _prepareStateMessageFrom(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return 'Conectando';
      case MQTTAppConnectionState.connecting:
        return 'Conectando';
      case MQTTAppConnectionState.disconnected:
        return 'Desconectado';
    }
  }

  void _configureAndConnect() {
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    manager = MQTTManager(
        host: "64.23.217.53",
        topic: "health1",
        identifier: osPrefix,
        state: currentAppState);
    manager.initializeMQTTClient();
    manager.connect();
  }

  void _disconnect() {
    manager.disconnect();
  }
}
