import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../../core/modules/Hardiot.dart';
import '../../core/modules/OurGps.dart';
import '../../core/modules/platformGps.dart';
import '../../core/utils/Utils.dart';
import '../../core/utils/constants.dart';
import '../../main.dart';

class CheckScreen extends StatefulWidget {
  final String serial;
  final double distance;
  const CheckScreen({Key? key, required this.serial, required this.distance})
      : super(key: key);
  @override
  _CheckScreenState createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  late Hardiot hardiot = Hardiot(
      lat: 0.0,
      lng: 0.0,
      checker: 0,
      evc: 0.0,
      lcid: 0.0,
      engineRpm: 0.0,
      fv: "",
      vehicleSpeed: 0.0,
      engineLoad: 0.0,
      coolantTemp: 0.0,
      odometer: 0.0,
      batLevel: 0.0,
      exVoltage: 0.0,
      fuelLevel: 0.0,
      csq: 0.0);
  late Ourgps ourgps = Ourgps(0.0, 0.0, 0);
  late PlatformGps platformGps =
      PlatformGps(0.0, 0.0, 0, DateTime.parse('0000-00-00'));

  late double distancepoint = 0.0;
  late double distanceplatform = 0.0;
  @override
  void initState() {
    super.initState();
    _hardiotstate();
  }

  @override
  void dispose() {
    super.dispose();
    mqttClient.unsubscribe('devices/${widget.serial}/events/');
  }

  _hardiotstate() async {
    mqttClient.subscribe('devices/${widget.serial}/events/gps');
    // if (platformGps.checker == 0) {
    //   setState(() {
    //     distanceplatform = Utils.calculateDistance(
    //         platformGps.lat, platformGps.lng, ourgps.lat, ourgps.lng);
    //   });
    // }
    mqttClient.onMessage(getMessage: (
        {lat,
        lng,
        evc,
        lcid,
        engineRpm,
        fv,
        vehicleSpeed,
        engineLoad,
        coolantTemp,
        odometer,
        batLevel,
        exVoltage,
        fuelLevel,
        csq}) async {
      if (hardiot.checker == 0) {
        setState(() {
          hardiot = Hardiot(
            lat: lat,
            lng: lng,
            checker: 1,
            evc: evc,
            lcid: lcid,
            engineRpm: engineRpm,
            fv: fv,
            vehicleSpeed: vehicleSpeed,
            engineLoad: engineLoad,
            coolantTemp: coolantTemp,
            odometer: odometer,
            batLevel: batLevel,
            exVoltage: exVoltage,
            fuelLevel: fuelLevel,
            csq: csq,
          );
        });
        await _currentLocation();
        // await _gpsPlatform();
        setState(() {
          distancepoint = Utils.calculateDistance(
              hardiot.lat, hardiot.lng, ourgps.lat, ourgps.lng);
        });
      }
    });
  }

  _currentLocation() async {
    late LocationData currentLocation;
    var location = Location();
    currentLocation = await location.getLocation();
    setState(() {
      ourgps = Ourgps(currentLocation.latitude, currentLocation.longitude, 1);
    });
  }

  // _gpsPlatform() async {
  //   Response response = await Utils.getGpsPlatform(widget.serial);
  //   var res;
  //   if (response.statusCode == 200) {
  //     res = jsonDecode(response.body);
  //     setState(() {
  //       platformGps = PlatformGps(
  //           double.parse(res['lat'].toString()),
  //           double.parse(res['lng'].toString()),
  //           1,
  //           DateTime.parse(res['updated_at']));
  //     });
  //   } else {
  //     setState(() {
  //       platformGps = PlatformGps(0.0, 0.0, -1, DateTime.parse('0000-00-00'));
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: _buildBody(),
      ),
    );
  }

  Widget returnStateHardiot(checker, size) {
    if (checker == 1) {
      return Icon(
        Icons.check_circle,
        color: AppColors.limeGreenColor,
        size: size.width / 13,
      );
    } else {
      return const CircularProgressIndicator(
        strokeWidth: 5,
        backgroundColor: Colors.blue,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  Widget returnStatePrecision(checker, size) {
    if (checker == 1 && distancepoint > 0 && distancepoint < widget.distance) {
      return Icon(
        Icons.check_circle,
        color: AppColors.limeGreenColor,
        size: size.width / 13,
      );
    } else {
      return Icon(
        Icons.highlight_remove_rounded,
        color: Colors.red,
        size: size.width / 13,
      );
    }
  }

  _buildBody() {
    var size = MediaQuery.of(context).size;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    // TextStyle style = TextStyle(
    //   fontSize: size.width / 30,
    // );
    return SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text(
                  widget.serial,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black.withOpacity(0.7)),
                ),
              ),
              Container(
                height: 80,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hardiot',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.9),
                          fontSize: size.width / 25),
                    ),
                    returnStateHardiot(hardiot.checker, size),
                  ],
                ),
              ),
              Container(
                height: 80,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'GPS Précision',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.9),
                          fontSize: size.width / 25),
                    ),
                    (hardiot.checker == 1 && distancepoint > widget.distance)
                        ? Text(
                            'distance plus grande que ${widget.distance} metre',
                            style: TextStyle(
                              color: Colors.grey.withOpacity(0.9),
                              fontSize: size.width / 40,
                            ),
                          )
                        : const Text(
                            ' ',
                          ),
                    returnStatePrecision(hardiot.checker, size),
                  ],
                ),
              ),
              // Container(
              //   height: 80,
              //   padding: const EdgeInsets.all(16),
              //   margin: const EdgeInsets.only(bottom: 16),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(12),
              //       color: Colors.white),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         'GPS Platform',
              //         style: TextStyle(
              //             color: Colors.black.withOpacity(0.9),
              //             fontSize: size.width / 25),
              //       ),
              //       (platformGps.checker == -1)
              //           ? Text(
              //               'imei pas trouvé',
              //               style: TextStyle(
              //                 color: Colors.grey.withOpacity(0.9),
              //                 fontSize: size.width / 40,
              //               ),
              //             )
              //           : const Text(
              //               ' ',
              //             ),
              //       (platformGps.checker == 1)
              //           ? Icon(
              //               Icons.check_circle,
              //               color: AppColors.limeGreenColor,
              //               size: size.width / 13,
              //             )
              //           : Icon(
              //               Icons.highlight_remove_rounded,
              //               color: Colors.red,
              //               size: size.width / 13,
              //             ),
              //     ],
              //   ),
              // ),
              Container(
                padding: (isPortrait)
                    ? const EdgeInsets.symmetric(vertical: 15)
                    : null,
                height: (isPortrait) ? size.height / 2.3 : size.height,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 0.2,
                      blurRadius: 10,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _customRow(
                      key: 'Mobile GPS',
                      value:
                          "lat: ${ourgps.lat!.toStringAsFixed(5)},lng: ${ourgps.lng!.toStringAsFixed(5)}",
                      check: ourgps.checker,
                    ),
                    _divider(),
                    _customRow(
                      key: 'hardiot GPS',
                      value:
                          "lat: ${hardiot.lat.toStringAsFixed(5)},lng: ${hardiot.lng.toStringAsFixed(5)}",
                      check: hardiot.checker,
                    ),
                    // _divider(),
                    // _customRow(
                    //   key: 'platform Gps',
                    //   value:
                    //       "lat: ${platformGps.lat!.toStringAsFixed(5)},lng: ${platformGps.lng!.toStringAsFixed(5)}",
                    //   check: platformGps.checker,
                    // ),
                    // _divider(),
                    // _customRow(
                    //   key: 'time lastUpdate',
                    //   value:
                    //       " ${platformGps.lastUpdate.toString().substring(0, 19)}",
                    //   check: platformGps.checker,
                    // ),
                    // _divider(),
                    // _customRow(
                    //   key: "distance entre Mobile et Platform GPS",
                    //   value: "${distanceplatform.toStringAsFixed(4)} Merte",
                    //   check: platformGps.checker,
                    // ),
                    /////////////////////////////////////////////////////////////////
                    _divider(),
                    _customRow(
                      key: "batLevel",
                      value: hardiot.batLevel.toStringAsFixed(4),
                      check: hardiot.checker,
                    ),
                    _divider(),
                    _customRow(
                      key: "csq",
                      value: hardiot.csq.toStringAsFixed(4),
                      check: hardiot.checker,
                    ),
                    _divider(),
                    _customRow(
                      key: "fuelLevel",
                      value: hardiot.fuelLevel.toStringAsFixed(4),
                      check: hardiot.checker,
                    ),
                    _divider(),
                    _customRow(
                      key: "exVoltage",
                      value: hardiot.exVoltage.toStringAsFixed(4),
                      check: hardiot.checker,
                    ),
                    _divider(),
                    _customRow(
                      key: "odometer",
                      value: hardiot.odometer.toStringAsFixed(4),
                      check: hardiot.checker,
                    ),
                    _divider(),
                    _customRow(
                      key: "coolantTemp",
                      value: hardiot.coolantTemp.toStringAsFixed(4),
                      check: hardiot.checker,
                    ),
                    _divider(),
                    _customRow(
                      key: "engineLoad",
                      value: hardiot.engineLoad.toStringAsFixed(4),
                      check: hardiot.checker,
                    ),
                    _divider(),
                    _customRow(
                      key: "vehicleSpeed",
                      value: hardiot.vehicleSpeed.toStringAsFixed(4),
                      check: hardiot.checker,
                    ),
                    _divider(),
                    _customRow(
                      key: "fv",
                      value: hardiot.fv,
                      check: hardiot.checker,
                    ),
                    _divider(),
                    _customRow(
                      key: "engineRpm",
                      value: hardiot.engineRpm.toStringAsFixed(4),
                      check: hardiot.checker,
                    ),
                    _divider(),
                    _customRow(
                      key: "lcid",
                      value: hardiot.lcid.toStringAsFixed(4),
                      check: hardiot.checker,
                    ),
                    _divider(),
                    _customRow(
                      key: "evc",
                      value: hardiot.evc.toStringAsFixed(4),
                      check: hardiot.checker,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 30,
      endIndent: 30,
      color: Colors.black.withOpacity(.2),
    );
  }

  Widget _customRow({key, value, check}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 20.2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: Text('$key',
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                )),
          ),
          (check == 1)
              ? Expanded(
                  flex: 1,
                  child: Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff99cdd1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  // _validButton({context}) {
  //   return InkWell(
  //     onTap: () async {
  //       //  String id = await BarcodeScanner.scan();
  //       await Utils.postchecker(widget.serial);
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.all(16),
  //       margin: const EdgeInsets.symmetric(horizontal: 16),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(180),
  //           color: AppColors.primaryColor),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: const [
  //           Text(
  //             'Valider',
  //             style: TextStyle(color: Colors.white, fontSize: 21),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // _retesterButton({context}) {
  //   return InkWell(
  //     onTap: () async {
  //       //  String id = await BarcodeScanner.scan();
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.all(16),
  //       margin: const EdgeInsets.symmetric(horizontal: 16),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(180),
  //           color: AppColors.maronDarkColor),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: const [
  //           Text(
  //             'Re-tester',
  //             style: TextStyle(color: Colors.white, fontSize: 21),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
