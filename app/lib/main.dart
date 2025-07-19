import 'package:flutter/material.dart';
import 'package:data_sdk/data_sdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final DataSDK sdk = DataSDK(apiUrl: "http://127.0.0.1:8000"); // Backend API URL

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Collector',
      home: DataCollectorScreen(sdk: sdk),
    );
  }
}

class DataCollectorScreen extends StatefulWidget {
  final DataSDK sdk;

  DataCollectorScreen({required this.sdk});

  @override
  _DataCollectorScreenState createState() => _DataCollectorScreenState();
}

class _DataCollectorScreenState extends State<DataCollectorScreen> {
  String _status = "Checking permissions...";
  List<String> _log = [];

  @override
  void initState() {
    super.initState();
    _initPermissions();
  }

  Future<void> _initPermissions() async {
    // Since we can't access SMS and call logs in the web, we simulate permissions
    setState(() {
      _status = "Permissions Granted (Simulated)";
    });
    await _simulateData();
  }

  // Simulate sending mock data for SMS and call logs
  Future<void> _simulateData() async {
    final mockData = [
      {
        'type': 'sms',
        'body': 'Your OTP is 123456',
        'sender': 'Bank',
      },
      {
        'type': 'call',
        'number': '123456789',
        'duration': 10,
      }
    ];

    for (var data in mockData) {
      if (data['type'] == 'sms') {
        print("Sending SMS event: $data");
        await widget.sdk.trackSMSEvent(data);
        _log.add("Sent SMS to SDK");
      } else if (data['type'] == 'call') {
        print("Sending Call Log event: $data");
        await widget.sdk.trackCallEvent(data);
        _log.add("Sent Call Log to SDK");
      }
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Data Collector")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Status: $_status"),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _log.length,
                itemBuilder: (context, index) => Text(_log[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
