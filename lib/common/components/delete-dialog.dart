import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fora_business/common/constants.dart';
import 'package:fora_business/controllers/auth-controller.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:momentum/momentum.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          height: (Platform.isAndroid)
              ? (250 / 844) * _height
              : (220 / 844) * _height,
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              child: Text(
                'Are you sure you want to delete your account?',
                style: TextStyle(color: Colors.red),
              ),
              margin: EdgeInsets.all(10),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: (10 / 390) * _width, vertical: 30),
              child: Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: tertiary,
                            fontFamily: 'sfprorounded',
                            fontSize: (16 / 844) * _height),
                      )),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Momentum.controller<AuthController>(context)
                                .handleDeleteUserAccount(context);
                          },
                          child: Text(
                            'Delete',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.red,
                                fontFamily: 'sfprorounded',
                                fontSize: (16 / 844) * _height),
                          )),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
