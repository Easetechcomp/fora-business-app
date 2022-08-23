import 'package:flutter/material.dart';
import 'package:fora_business/common/components/regular_text_input_new.dart';
import 'package:fora_business/common/components/signin-button.dart';
import 'package:fora_business/controllers/auth-controller.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:momentum/momentum.dart';

import '../constants.dart';

class NewPasswordViewSheet extends StatefulWidget {
  final isCurrentPasswordUsed;
  const NewPasswordViewSheet({
    Key? key,
    this.isCurrentPasswordUsed = false,
  }) : super(key: key);

  @override
  State<NewPasswordViewSheet> createState() => _MembershipBottomSheetState();
}

class _MembershipBottomSheetState extends State<NewPasswordViewSheet> {
  final _currentPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureText = true;
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  void _showPassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _showNewPassword() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  void _showConfirmNewPassword() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: (widget.isCurrentPasswordUsed)
            ? (300 / 844) * _height
            : (260 / 844) * _height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF18344A),
                Color(0xFF152532),
              ],
            )),
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (widget.isCurrentPasswordUsed)
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: (35 / 390) * _width),
                        child: RegularTextInputNew(
                          protectedText: _obscureText,
                          showPassword: _showPassword,
                          controller: _currentPasswordController,
                          labelColor: tertiary,
                          textColor: tertiary,
                          password: true,
                          fillColor: Color(0x21FFFFFF),
                          hintTextColor: Color(0x94FFFFFF),
                          prefixIconColor: Color(0x94192B37),
                          errorBorderColor: Color(0xFFFD7542),
                          label: "Current Password",
                          hintText: "Current Password",
                        ),
                      )
                    : SizedBox(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: (35 / 390) * _width),
                  child: RegularTextInputNew(
                    protectedText: _obscureText1,
                    showPassword: _showNewPassword,
                    controller: _passwordController,
                    labelColor: tertiary,
                    textColor: tertiary,
                    password: true,
                    fillColor: Color(0x21FFFFFF),
                    hintTextColor: Color(0x94FFFFFF),
                    prefixIconColor: Color(0x94192B37),
                    errorBorderColor: Color(0xFFFD7542),
                    label: "New Password",
                    hintText: "New Password",
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      // bottom: (20 / 844) * _height,
                      right: (35 / 390) * _width,
                      left: (35 / 390) * _width),
                  child: RegularTextInputNew(
                    protectedText: _obscureText2,
                    showPassword: _showConfirmNewPassword,
                    controller: _confirmPasswordController,
                    labelColor: tertiary,
                    textColor: tertiary,
                    confirmPassword: true,
                    fillColor: Color(0x21FFFFFF),
                    hintTextColor: Color(0x94FFFFFF),
                    prefixIconColor: Color(0x94192B37),
                    errorBorderColor: Color(0xFFFD7542),
                    label: "Confirm New Password",
                    hintText: "Confirm New Password",
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: (30 / 844) * _height),
                  child: SignInButton(
                    survey: false,
                    onPressed: () {
                      if (!widget.isCurrentPasswordUsed) {
                        Momentum.controller<AuthController>(context)
                            .handleChangePasswordUsingPhoneNumber(
                                _passwordController.text,
                                _confirmPasswordController.text,
                                context);
                      } else {
                        Momentum.controller<AuthController>(context)
                            .handleUserChangePassword(
                                _currentPasswordController.text,
                                _passwordController.text,
                                _confirmPasswordController.text,
                                context);
                      }
                    },
                    signIn: false,
                    getStarted: true,
                    title: 'Change Password',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
