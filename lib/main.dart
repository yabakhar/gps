import 'package:flutter/material.dart';
import 'package:gps_checker/screens/check_user/selectWorker.dart';

import 'core/routes/route_generator.dart';
import 'core/utils/mqtt.dart';

MqttClient mqttClient = MqttClient();
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SelectWorker(),
    );
  }
}
