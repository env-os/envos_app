import 'package:flutter/material.dart';
import 'package:envos/view/login_view.dart';
import 'package:envos/presenter/auth_base.dart';
import 'package:envos/view/area_view.dart';
import 'package:envos/view/add_area_view.dart';
import 'package:envos/view/add_device_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final auth = new Auth();
  final String gatewayAddr = "https://public-api-gateway.herokuapp.com";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'envOS',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      home: LoginPage(auth: auth),

      routes: {
        '/home': (context) =>
            AreasPage(title: "Home Page", auth: auth, gatewayAddr: gatewayAddr),
        '/addarea': (context) =>
            AddArea(title: "Nuova Area", auth: auth, gatewayAddr: gatewayAddr),
        '/adddevice': (context) =>
            AddDevice(
                title: "Nuovo Device", auth: auth, gatewayAddr: gatewayAddr),
      },
    );
  }
}

