import 'package:flutter/material.dart';
import 'package:fora_business/common/components/regular_text_input_new.dart';
import 'package:fora_business/controllers/auth-controller.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:momentum/momentum.dart';

import '../constants.dart';
import 'signin-button.dart';

class ForgotPasswordSheet extends StatefulWidget {
  const ForgotPasswordSheet({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

TextEditingController controller = TextEditingController();

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  bool email = false;
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return MomentumBuilder(builder: (context, snapshot) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: (250 / 844) * _height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // ignore: prefer_const_literals_to_create_immutables
                colors: [
                  Color(0xFF18344A),
                  Color(0xFF152532),
                ],
              )),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (email)
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: (35 / 390) * _width),
                        child: RegularTextInputNew(
                          controller: controller,
                          labelColor: tertiary,
                          textColor: tertiary,
                          email: true,
                          fillColor: const Color(0x21FFFFFF),
                          hintTextColor: const Color(0x94FFFFFF),
                          prefixIconColor: const Color(0x94192B37),
                          errorBorderColor: const Color(0xFFFD7542),
                          label: "Email address",
                          hintText: "Email address",
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: (35 / 390) * _width),
                        child: RegularTextInputNew(
                          controller: controller,
                          labelColor: tertiary,
                          textColor: tertiary,
                          phoneNumber: true,
                          fillColor: const Color(0x21FFFFFF),
                          hintTextColor: const Color(0x94FFFFFF),
                          prefixIconColor: const Color(0x94192B37),
                          errorBorderColor: const Color(0xFFFD7542),
                          label: "Phone number",
                          hintText: "Phone number",
                        ),
                      ),
                Container(
                  margin: EdgeInsets.only(top: (30 / 844) * _height),
                  child: SignInButton(
                    survey: false,
                    onPressed: () {
                      if (!email) {
                        print(controller.text);
                        Momentum.controller<AuthController>(context)
                            .handleSendCodeUsingPhoneNumber(
                          "+2" + controller.text,
                          false,
                          context,
                        );
                      } else {}
                    },
                    signIn: false,
                    getStarted: true,
                    title: 'Forget Password',
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
