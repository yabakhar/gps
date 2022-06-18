import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

late PermissionStatus isGrant;
Future<String?> scanQR() async {
  var cameraStatus = await Permission.camera.status;
  if (cameraStatus.isGranted) {
    try {
      String? cameraScanResult = await scanner.scan();
      return cameraScanResult;
    } on PlatformException catch (e) {
      print(e);
      return null;
    }
  } else
    isGrant = await Permission.camera.request();
}
