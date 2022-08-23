// @dart=2.9
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fora_business/controllers/auth-controller.dart';
import 'package:momentum/momentum.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'common/constants.dart';
import 'views/sign-in-view.dart';

var token;
var fcmToken;

/// To display notifications while app in the background

Future<void> main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(momentum());
  });
}

Momentum momentum() {
  return Momentum(
    controllers: [AuthController()],
    child: MyApp(),
    // persistSave: (context, key, value) async {
    //   var sharedPref = await SharedPreferences.getInstance();
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   token = prefs.getString('token');
    //   var result = await sharedPref.setString(key, value);
    //   return result;
    // },
    // persistGet: (context, key) async {
    //   var sharedPref = await SharedPreferences.getInstance();
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   token = prefs.getString('token');
    //   var result = sharedPref.getString(key);
    //   return result;
    // },
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends MomentumState<MyApp> {
  bool verified = false;

  @override
  Future<void> initMomentumState() async {
    super.initMomentumState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: secondary,
      debugShowCheckedModeBanner: false,
      title: 'Fora',
      theme: ThemeData(),
      home: MomentumBuilder(builder: (context, snapshot) {
        // var model = snapshot<AuthModel>();
        // var ticketsModel = snapshot<TicketsModel>();
        return SplashScreen(
          useLoader: false,
          seconds: 5,
          navigateAfterSeconds: SignIn(),
          backgroundColor: secondary,
          imageBackground: const AssetImage("lib/assets/Split Screen.png"),
        );
      }),
    );
  }
}
