import '../modules/Hardiot.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'dart:math' show cos, sqrt, asin;

class Utils {
  static Future qrcodeScanner() async {
    String? qrResult = await scanner.scan();
    
    print('qrResult=> $qrResult');
    if (qrResult == null) {
      print('nothing return.');
      return null;
    }

    return qrResult;
  }

  static String getAssetsIcon(String s) {
    return 'assets/images/$s';
  }

  static bool isNumeric(String? s) {
    print('start isNumeric $s');
    if (s == null || s.isEmpty) {
      print('result is not numeric');
      return false;
    }
    print('result is numeric');
    return double.tryParse(s) != null;
  }

  static Hardiot decode(var bytes) {
    var splitted = [];
    Hardiot hardiot;
    for (int i = 0; i < bytes.length; i = i + 2) {
      splitted.add(int.parse(bytes.substring(i, i + 2), radix: 16));
    }

    var lat = splitted.sublist(6, 11);
    var lng = splitted.sublist(11, 16);
    var padsLat = "";
    var padsLng = "";
    var latNb = (lat[0] & 0x7F) * 256 + lat[1];
    var lngNb = (lng[0] & 0x7F) * 256 + lng[1];
    var latFp = (lat[2] << 16) | (lat[3] << 8) | lat[4];
    var lngFp = (lng[2] << 16) | (lng[3] << 8) | lng[4];
    var evc = splitted[0];
    var lcid = splitted[1] + splitted[2];
    var fv = "${splitted[3]}.${splitted[4]}.${splitted[5]}";
    var engineRpm = (splitted[16] << 8) + splitted[17];
    var vehicleSpeed = splitted[18];
    var engineLoad = (splitted[19]) / 2.55;
    var coolantTemp = (splitted[20]) - 40;
    var fuelLevel = splitted[21];
    var odometer = (splitted[22] << 16) + (splitted[23] << 8) + splitted[24];
    var exVoltage = ((splitted[25] << 8) + splitted[26]) * 0.0044;
    var batLevel = ((splitted[27] << 8) + splitted[28]) / 1000.0;
    var csq = splitted[33];
    var tmp = lat[0];
    if ((tmp >> 7) == 1) latNb = -latNb;
    tmp = lng[0];
    if ((tmp >> 7) == 1) lngNb = -lngNb;
    for (var index = 0; index < 7 - latFp.toString().length; index++) {
      padsLat += "0";
    }
    for (var index = 0; index < 7 - lngFp.toString().length; index++) {
      padsLng += "0";
    }
    var outputLat = double.parse("$latNb.$padsLat$latFp");
    var outputLng = double.parse("$lngNb.$padsLng$lngFp");
    print(outputLng);
    print(outputLat);
    hardiot = Hardiot(
      lat: outputLat,
      lng: outputLng,
      checker: 1,
      evc: double.parse(evc.toString()),
      lcid: double.parse(lcid.toString()),
      engineRpm: double.parse(engineRpm.toString()),
      fv: fv.toString(),
      vehicleSpeed: double.parse(vehicleSpeed.toString()),
      engineLoad: double.parse(engineLoad.toString()),
      coolantTemp: double.parse(coolantTemp.toString()),
      odometer: double.parse(odometer.toString()),
      batLevel: double.parse(batLevel.toString()),
      exVoltage: double.parse(exVoltage.toString()),
      fuelLevel: double.parse(fuelLevel.toString()),
      csq: double.parse(csq.toString()),
    );
    return (hardiot);
  }

  static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return (12742 * asin(sqrt(a))) * 1000;
  }

  static Future getGpsPlatform(String code) async {
    try {
      final client = RetryClient(http.Client());
      String url = "https://api.fleet.digieye.io/api/test/device?imei=$code";
      final http.Response response = await client.get(Uri.parse(url));
      return response;
    } catch (e) {
      print("response error");
    }
  }
}
