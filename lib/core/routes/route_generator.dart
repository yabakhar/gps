import 'package:flutter/material.dart';
import '../../screens/check/CheckScreen.dart';
import '../../screens/home/HomeScreen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/check':
        var params = args as dynamic;
        return MaterialPageRoute(
            builder: (_) => CheckScreen(
                  serial: params['serial'],
                  distance: params['distance'],
                ));

      // case '/login':
      //   return MaterialPageRoute(builder: (_) => LoginPage());

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
