import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fora_business/common/components/forgot-password-sheet.dart';

import '../constants.dart';

class ForgotPasswordTextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      width: _width,
      child: RichText(
          text: TextSpan(
        text: "Forgot password?",
        style: TextStyle(
          fontSize: (12 / 844) * _height,
          color: primary,
          fontFamily: 'SfProRounded',
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return ForgotPasswordSheet();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular((200.0 / 390) * _width),
                ),
              ),
            );
          },
      )),
    );
  }
}
