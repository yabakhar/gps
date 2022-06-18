import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';

import 'checkUser.dart';

class SelectWorker extends StatefulWidget {
  const SelectWorker({Key? key}) : super(key: key);

  @override
  State<SelectWorker> createState() => _SelectWorkerState();
}

class _SelectWorkerState extends State<SelectWorker> {
  String Worker = "amqp_worker18";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("select your Worker"),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(size.height / 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FastDropdown<String>(
                name: 'dropdown',
                labelText: 'Wokers',
                items: const [
                  'amqp_worker9',
                  'amqp_worker10',
                  'amqp_worker11',
                  'amqp_worker12',
                  'amqp_worker13',
                  'amqp_worker14',
                  'amqp_worker15',
                  'amqp_worker16',
                  'amqp_worker17',
                  'amqp_worker18',
                  'amqp_worker19',
                  'amqp_worker20',
                  'amqp_worker21',
                  'amqp_worker22',
                  'amqp_worker23',
                  'amqp_worker24',
                  'amqp_worker25',
                ],
                onChanged: (value) {
                  get_worker(value);
                },
                initialValue: Worker,
              ),
              SizedBox(
                height: size.height / 30,
              ),
              FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => CheckUser(
                              worker: Worker,
                            ),
                          ),
                        ),
                      },
                  child: const Text("Select")),
            ],
          ),
        ),
      ),
    );
  }

  get_worker(String? value) {
    setState(() {
      Worker = value!;
    });
  }
}
