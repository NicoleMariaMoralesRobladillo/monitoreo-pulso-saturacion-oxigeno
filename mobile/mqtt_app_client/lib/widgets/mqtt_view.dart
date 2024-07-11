import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:mqtt_app_client/model/measure.dart';
import 'package:mqtt_app_client/mqtt/mqtt_manager.dart';
import 'package:mqtt_app_client/mqtt/state/mqtt_app_state.dart';
import 'package:mqtt_app_client/widgets/background.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

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
    final Scaffold scaffold = Scaffold(
        backgroundColor: Colors.black,
        body: CustomPaint(
          painter: BacgroundPaint(),
          child: _buildColumn(),
        ));
    return scaffold;
  }

  Widget _buildColumn() {
    return Column(
      children: <Widget>[
        _buildConnectionStateText(
            _prepareStateMessageFrom(currentAppState.getAppConnectionState)),
        const SizedBox(height: 140),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Stack(alignment: Alignment.center, children: [
              DemoCircleWave(
                count: 200,
                isProcessing: false,
              ),
              Transform.rotate(
                  angle: -0.3,
                  child: LottieBuilder.asset(
                    "assets/heart_bubble.json",
                  ))
            ])),
        const SizedBox(height: 140),
        _buildEditableColumn(),
        _buildMeasure(currentAppState.getReceivedText),
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
              color: Colors.orange,
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
              backgroundColor: state == MQTTAppConnectionState.connected
                  ? Colors.white
                  : Colors.green,
            ),
            onPressed: state == MQTTAppConnectionState.disconnected
                ? _configureAndConnect
                : _nothing,
            child: const Text(
              'Conectar',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: state == MQTTAppConnectionState.connected
                  ? Colors.red
                  : Colors.white,
            ),
            onPressed: state == MQTTAppConnectionState.connected
                ? _disconnect
                : _nothing,
            child: const Text(
              'Desconectar',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMeasure(String text) {
    if (text.isEmpty) {
      return const Center(
        child: Text(
          'No se han recibido datos.',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      );
    }

    try {
      Map<String, dynamic> measureJson = jsonDecode(text);
      Measure measure = Measure.fromJson(measureJson);

      List<Widget> measureWidgets = [];

      measureWidgets.add(Text(
        'Saturación de Oxígeno: ${measure.spo2Rate}%',
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ));
      if (measure.spo2Rate < 90) {
        measureWidgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Advertencia: ¡Saturación de oxígeno baja!',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
          ),
        );
      }

      measureWidgets.add(const SizedBox(height: 20));

      measureWidgets.add(Text(
        'Frecuencia Cardíaca: ${measure.heartRate} bpm',
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ));
      if (measure.heartRate > 120) {
        measureWidgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Advertencia: ¡Frecuencia cardíaca alta!',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
          ),
        );
      } else if (measure.heartRate < 50) {
        measureWidgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Advertencia: ¡Frecuencia cardíaca baja!',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
          ),
        );
      }
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: measureWidgets,
        ),
      );
    } catch (e) {
      return const Center(
        child: Text(
          'Error al procesar los datos.',
          style: TextStyle(fontSize: 24, color: Colors.red),
        ),
      );
    }
  }

  String _prepareStateMessageFrom(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return 'Conectado';
      case MQTTAppConnectionState.connecting:
        return 'Conectando';
      case MQTTAppConnectionState.disconnected:
        return 'Desconectado';
      default:
        return 'Estado desconocido';
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

  void _nothing() {}
}
