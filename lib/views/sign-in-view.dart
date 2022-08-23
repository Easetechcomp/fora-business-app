// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fora_business/common/components/forgot-password-text.dart';
import 'package:fora_business/common/components/regular_text_input_new.dart';
import 'package:fora_business/common/components/sign-up-here-text.dart';
import 'package:fora_business/controllers/auth-controller.dart';
import 'package:fora_business/view_models/auth-model.dart';
import 'package:momentum/momentum.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../common/components/signin-button.dart';
import '../common/constants.dart';
import 'package:flushbar/flushbar.dart';

class SignIn extends StatefulWidget {
  final bool triggerLogoutEvent;
  SignIn({this.triggerLogoutEvent = false});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends MomentumState<SignIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  void _showPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _submit() async {
    _tryConnection();
    if (_isConnectionSuccessful != false) {
      if (_formKey.currentState!.validate()) {
        Momentum.controller<AuthController>(context).handleEmailLogin(
            _emailController.text, _passwordController.text, context);
      }
    }
  }

  late StreamSubscription _connectivitySubscription;
  bool? _isConnectionSuccessful;

  void initMomentumState() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print('Current connectivity status: $result');
      _tryConnection();
      _tryConnection();
      setState(() {});
    });

    super.initMomentumState();
  }

  Future<void> _tryConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');

      setState(() {
        _isConnectionSuccessful = response.isNotEmpty;
      });
    } on SocketException catch (e) {
      print(e);
      setState(() {
        _isConnectionSuccessful = false;
      });
    }
  }

  dispose() {
    super.dispose();

    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return MomentumBuilder(
        controllers: [],
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor:
                Colors.white, //set the colors of the scaffold is white
            body: GestureDetector(
              onTap: () {
                if (_isConnectionSuccessful == false) {
                  _tryConnection();
                }
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFBFBFE),
                        Color(0xFFECEFFD),
                      ],
                    )),
                    // decoration: BoxDecoration(
                    //   gradient:
                    // ),
                    child: Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        Container(
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            'lib/assets/TennisHome.png',
                            alignment: Alignment.topRight,
                            width: (150 / 390) * _width,
                            height: (270 / 844) * _height,
                          ),
                        ),
                        Positioned(
                          top: (700 / 844) * _height,
                          // right: (240 / 390) * _width,
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Image.asset(
                              'lib/assets/BasketballHome.png',
                              alignment: Alignment.bottomLeft,
                              width: (150 / 390) * _width,
                              height: (150 / 844) * _height,
                            ),
                          ),
                        ),
                        Container(
                          child: SafeArea(
                            child: ListView(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                    left: (29 / 390) * _width,
                                    top: (30 / 844) * _height,
                                  ),
                                  child: Image.asset(
                                    'lib/assets/fora-logo.png',
                                    height: (59 / 844) * _height,
                                    width: (111 / 390) * _width,
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(
                                      top: (129 / 844) * _height,
                                      left: (29 / 390) * _width),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text.rich(
                                            TextSpan(children: <InlineSpan>[
                                          TextSpan(
                                            text: 'Sign in',
                                            style: TextStyle(
                                              color: secondary,
                                              fontSize: 42,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'SfProRounded',
                                            ),
                                          ),
                                        ])),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(
                                      left: (35 / 390) * _width,
                                      right: (35 / 390) * _width,
                                      // top: (19 / 844) * _height,
                                      bottom: (19 / 844) * _height),
                                  child: Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            // color: Colors.pink,
                                            height: (72 / 844) * _height,
                                            child: RegularTextInputNew(
                                              labelColor: secondary,
                                              textColor: secondary,
                                              fillColor: Color(0x21214461),
                                              hintTextColor: Color(0x940A1F33),
                                              prefixIconColor:
                                                  Color(0x94192B37),
                                              errorBorderColor:
                                                  Color(0xFFFD7542),
                                              email: true,
                                              label: "Email address",
                                              hintText: "Email address",
                                              controller: _emailController,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                bottom: (2 / 844) * _height),
                                            child: RegularTextInputNew(
                                              labelColor: secondary,
                                              textColor: secondary,
                                              fillColor: Color(0x21214461),
                                              hintTextColor: Color(0x940A1F33),
                                              prefixIconColor:
                                                  Color(0x94192B37),
                                              errorBorderColor:
                                                  Color(0xFFFD7542),
                                              password: true,
                                              label: "Password",
                                              hintText: "Password",
                                              protectedText: _obscureText,
                                              controller: _passwordController,
                                              showPassword: _showPassword,
                                            ),
                                          ),
                                          ForgotPasswordTextButton(),
                                        ],
                                      )),
                                ),
                                MomentumBuilder(
                                    controllers: [AuthController],
                                    builder: (context, snapshot) {
                                      var loadingState =
                                          snapshot<AuthModel>().loginInProgress;
                                      return (loadingState)
                                          ? Center(
                                              child: HeartbeatProgressIndicator(
                                                duration:
                                                    Duration(milliseconds: 500),
                                                // numberOfDots: 5,
                                                startScale: 0.5,
                                                endScale: 1,
                                                // fontSize: 50,
                                                child: Container(
                                                  child: Image.asset(
                                                    "lib/assets/fora.png",
                                                    // height: 10,
                                                    width: 30,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SignInButton(
                                              getStarted: false,
                                              signIn: true,
                                              onPressed: _submit,
                                            );
                                    }),

                                // ListView(
                                //   scrollDirection: Axis.horizontal,
                                // )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  (_isConnectionSuccessful != false)
                      ? SizedBox()
                      : Flushbar(
                          icon: Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 26,
                          ),
                          title: "no internet connection",
                          flushbarPosition: FlushbarPosition.TOP,
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                          barBlur: 2,
                          backgroundColor: Color.fromRGBO(247, 54, 54, 0.9),
                          message: "please connect to the internet",
                        ),
                ],
              ),
            ),
          );
        });
  }
}
