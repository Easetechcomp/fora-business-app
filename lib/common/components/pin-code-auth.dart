import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fora_business/common/components/flush.dart';
import 'package:fora_business/common/constants.dart';
import 'package:fora_business/controllers/auth-controller.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:momentum/momentum.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'signin-button.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final String? phoneNumber;
  final bool verifyingPhoneNumber;

  const PinCodeVerificationScreen({
    Key? key,
    this.phoneNumber,
    this.verifyingPhoneNumber = false,
  }) : super(key: key);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController pinCodeController = TextEditingController();
  final tempToken = "";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Container(
      height: 400,
      color: secondary,
      child: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Phone Number Verification',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: tertiary),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: "${widget.phoneNumber}",
                            style: const TextStyle(
                                color: tertiary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: const TextStyle(color: tertiary, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: true,
                      obscuringCharacter: '*',
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return;
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: tertiary,
                          selectedFillColor: primary,
                          selectedColor: primary,
                          activeColor: secondary,
                          inactiveColor: secondary,
                          inactiveFillColor: tertiary),
                      cursorColor: primary,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: pinCodeController,
                      keyboardType: TextInputType.number,
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        debugPrint("Completed");
                      },
                      onChanged: (value) {
                        debugPrint(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        return true;
                      },
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the code? ",
                    style: TextStyle(color: tertiary, fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () {
                      if (widget.verifyingPhoneNumber) {
                        Momentum.controller<AuthController>(context)
                            .handleSendCodeForPhoneVerification(
                                widget.phoneNumber, context);
                      } else {
                        Momentum.controller<AuthController>(context)
                            .handleSendCodeUsingPhoneNumber(
                                widget.phoneNumber, true, context);
                      }

                      notifySuccess(context, message: "OTP resent!!");
                    },
                    child: const Text(
                      "RESEND",
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              Container(
                margin: EdgeInsets.only(top: (10 / 844) * _height),
                child: SignInButton(
                  survey: false,
                  onPressed: () {
                    formKey.currentState!.validate();

                    if (pinCodeController.text.length != 6) {
                      errorController!.add(ErrorAnimationType
                          .shake); // Triggering error shake animation
                      setState(() => hasError = true);
                      notifyError(context,
                          message: "Please fill up all the cells properly");
                    } else {
                      print(pinCodeController.text);
                      if (widget.verifyingPhoneNumber) {
                        Momentum.controller<AuthController>(context)
                            .handleVerifyCodePhoneNumberVerification(
                                pinCodeController.text,
                                widget.phoneNumber,
                                context);
                      } else {
                        // forgot password
                        Momentum.controller<AuthController>(context)
                            .handleVerifyCodeUsingPhoneNumber(
                                pinCodeController.text,
                                widget.phoneNumber,
                                context);
                      }
                    }
                  },
                  signIn: false,
                  getStarted: true,
                  title: 'Verify Code',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
