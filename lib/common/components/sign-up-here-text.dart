import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fora_business/views/sign-in-view.dart';

import '../constants.dart';

// ignore: must_be_immutable
class SignUpHereButton extends StatelessWidget {
  final bool signUp;
  bool survey = false;
  SignUpHereButton({
    required this.signUp,
    this.survey = false,
  });
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      width: _width,
      child: RichText(
          text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: (!signUp)
                  ? 'Not a User? '
                  : (signUp && !survey)
                      ? 'Already a User? '
                      : 'Welcome to Fora app',
              style: TextStyle(
                fontSize: (16 / 844) * _height,
                color: secondary,
                fontFamily: 'SfProRounded',
              )),
          TextSpan(
            text: (!signUp)
                ? "Register"
                : (signUp && !survey)
                    ? "Log in"
                    : null,
            style: TextStyle(
              fontSize: (16 / 844) * _height,
              color: primary,
              fontWeight: FontWeight.bold,
              fontFamily: 'SfProRounded',
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
          )
        ],
      )),
    );
  }
}
