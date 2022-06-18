import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class AppSnackBar {
  static void error(String error, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }

  static void info(String msg, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green.shade700,
    ));
  }

  static Future<void> customAlert(context, res, style) async {
    // var user = await StorageService.get('connectedUser');
    // SweetAlertV2.show(context,
    //     subtitle: ".....", style: SweetAlertV2Style.loading);
    // new Future.delayed(new Duration(seconds: 2), () {
    //   SweetAlertV2.show(context, subtitle: res['message'], style: style,
    //       onPress: (bool isConfirm) {
    //     Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false,
    //         arguments: user['user']);
    //     return false;
    //   });
    // });
  }

  static confirmDialog(context) {
    return confirm(
      context,
      // title: Text('Confirmer'),
      content: const Text("Êtes-vous sûr de continue ?"),
      textOK: const Text(
        'Oui',
        style: TextStyle(color: AppColors.primaryColor),
      ),
      textCancel:
          const Text('Non', style: TextStyle(color: AppColors.primaryColor)),
    );
  }
}
