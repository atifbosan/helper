import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChannelPlatformCallView extends StatefulWidget {
  ChannelPlatformCallView({Key? key}) : super(key: key);

  @override
  State<ChannelPlatformCallView> createState() =>
      _ChannelPlatformCallViewState();
}

class _ChannelPlatformCallViewState extends State<ChannelPlatformCallView> {
  final platform = MethodChannel('exampleMethod');
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Excel Export Example')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _getBatteryLevel,
            child: const Text('Get Battery Level'),
          ),
          Text(_batteryLevel),
        ],
      ),
    );
  }
}
