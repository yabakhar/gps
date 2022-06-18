import 'package:flutter/material.dart';

import '../../main.dart';
import '../home/HomeScreen.dart';

class CheckUser extends StatefulWidget {
  String worker;
  CheckUser({Key? key, required this.worker}) : super(key: key);

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  int result = 0;

  void connectUser() async {
    print(
        "==========================================>>>>${widget.worker}<<<<<==========================================");
    try {
      bool res = await mqttClient.init('mqtt2.hardiot.com', widget.worker);
      if (res == true) {
        setState(() {
          result = 1;
        });
      } else {
        setState(() {
          result = -1;
        });
      }
      print("==========================================>>>>>>$result");
    } catch (e) {
      setState(() {
        result = -1;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectUser();
  }

  @override
  Widget build(BuildContext context) {
    if (result == 0) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("Waiting .....")),
      );
    } else if (result == 1) {
      return const HomeScreen();
    } else {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("Try to get another Worker .....")),
      );
    }
  }
}
