import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;
  List<BluetoothService> services = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Blue Example'),
      ),
      body: connectedDevice == null ? buildScanList() : buildDeviceView(),
      floatingActionButton: StreamBuilder<bool>(
        stream: flutterBlue.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => flutterBlue.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: () =>
                  flutterBlue.startScan(timeout: Duration(seconds: 4)),
            );
          }
        },
      ),
    );
  }

  Widget buildScanList() {
    return StreamBuilder<List<ScanResult>>(
      stream: flutterBlue.scanResults,
      initialData: [],
      builder: (c, snapshot) => Column(
        children: snapshot.data!
            .map(
              (result) => ListTile(
                title: Text(result.device.name),
                subtitle: Text(result.device.id.toString()),
                onTap: () {
                  flutterBlue.stopScan();
                  connectToDevice(result.device);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    setState(() {
      connectedDevice = device;
    });
    discoverServices(device);
  }

  void discoverServices(BluetoothDevice device) async {
    var services = await device.discoverServices();
    setState(() {
      this.services = services;
    });
  }

  Widget buildDeviceView() {
    return ListView(
      children: services
          .map(
            (service) => ListTile(
              title: Text('Service: ${service.uuid}'),
              subtitle: Column(
                children: service.characteristics
                    .map(
                      (c) => ListTile(
                        title: Text('Characteristic: ${c.uuid}'),
                        subtitle: StreamBuilder<List<int>>(
                          stream: c.value,
                          initialData: [],
                          builder: (context, snapshot) {
                            return Text(snapshot.data.toString());
                          },
                        ),
                        onTap: () async {
                          if (c.properties.read) {
                            await c.read();
                          }
                          if (c.properties.write) {
                            await c.write([0x12, 0x34]);
                          }
                          if (c.properties.notify) {
                            await c.setNotifyValue(true);
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          )
          .toList(),
    );
  }
}
