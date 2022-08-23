import 'package:flutter/material.dart';
import 'package:fora_business/common/components/new-password-sheet.dart';
import 'package:fora_business/common/components/regular_text_input_new.dart';
import 'package:fora_business/controllers/auth-controller.dart';
import 'package:fora_business/views/sign-in-view.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:momentum/momentum.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/components/delete-dialog.dart';
import '../common/constants.dart';
import '../view_models/auth-model.dart';

class UserProfile extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<UserProfile> {
  void initState() {
    super.initState();
  }

  bool showMessageBox = false;
  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => SignIn(
            triggerLogoutEvent: true,
          ),
        ),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return MomentumBuilder(
        controllers: [AuthController],
        builder: (context, snapshot) {
          var currentUser = snapshot<AuthModel>().currentUser;
          var currentAuth = snapshot<AuthModel>();
          return Scaffold(
              key: _scaffoldKey,
              body: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color(0xFFFBFBFE),
                      Color(0xFFECEFFD),
                    ])),
                child: ListView(children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: (30 / 844) * _width,
                      bottom: (40 / 844) * _width,
                      left: (28 / 390) * _width,
                      right: (28 / 390) * _width,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            right: (6 / 390) * _width,
                          ),
                          width: (10 / 390) * _width,
                          height: (30 / 844) * _height,
                          decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(2)),
                        ),
                        Text.rich(TextSpan(children: <InlineSpan>[
                          TextSpan(
                            text: 'Profile',
                            style: TextStyle(
                              color: secondary,
                              fontSize: (36 / 844) * _height,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SfProRounded',
                            ),
                          ),
                        ])),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: (28 / 390) * _width,
                      right: (28 / 390) * _width,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: (68 / 844) * _height,
                              width: 0.4 * _width,
                              child: RegularTextInputNew(
                                labelColor: secondary,
                                textColor: secondary,
                                fillColor: Color(0x21797979),
                                hintTextColor: Color(0x940A1F33),
                                prefixIconColor: Color(0x94192B37),
                                errorBorderColor: Color(0xFFFD7542),
                                name: true,
                                disable: true,
                                label: "First Name",
                                hintText: currentUser.firstName,
                              ),
                            ),
                            SizedBox(
                              width: (10 / 390) * _width,
                            ),
                            Expanded(
                              child: Container(
                                height: (68 / 844) * _height,
                                // margin: EdgeInsets.only(left: 5),
                                // width: 0.4 * _width,
                                child: RegularTextInputNew(
                                  labelColor: secondary,
                                  textColor: secondary,
                                  fillColor: Color(0x21797979),
                                  hintTextColor: Color(0x940A1F33),
                                  prefixIconColor: Color(0x94192B37),
                                  errorBorderColor: Color(0xFFFD7542),
                                  name: true,
                                  disable: true,
                                  label: "Last Name",
                                  hintText: currentUser.lastName,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: (68 / 844) * _height,
                          child: RegularTextInputNew(
                            labelColor: secondary,
                            textColor: secondary,
                            fillColor: Color(0x21797979),
                            hintTextColor: Color(0x940A1F33),
                            prefixIconColor: Color(0x94192B37),
                            errorBorderColor: Color(0xFFFD7542),
                            phoneNumber: true,
                            label: "Phone Number",
                            hintText: currentUser.phoneNumber,
                            keyboardType: TextInputType.number,
                            disable: true,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: (68 / 844) * _height,
                              child: RegularTextInputNew(
                                labelColor: secondary,
                                textColor: secondary,
                                fillColor: Color(0x21797979),
                                hintTextColor: Color(0x940A1F33),
                                prefixIconColor: Color(0x94192B37),
                                errorBorderColor: Color(0xFFFD7542),
                                email: true,
                                label: "Email",
                                hintText: currentAuth.email,
                                disable: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        // alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            right: (80 / 390) * _width,
                            left: (28 / 390) * _width),
                        child: TextButton(
                            onPressed: () {
                              showModalBottomSheet<void>(
                                  // barrierColor: Colors.blue,
                                  // backgroundColor: Colors.red,

                                  context: context,
                                  builder: (BuildContext context) {
                                    return NewPasswordViewSheet(
                                      isCurrentPasswordUsed: true,
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(
                                        (25.0),
                                      ),
                                    ),
                                  ));
                            },
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                  color: primary,
                                  fontFamily: 'sfprorounded',
                                  fontWeight: FontWeight.w600,
                                  fontSize: (16 / 844) * _height),
                            )),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: logout,
                          child: Container(
                            margin: EdgeInsets.only(
                              left: (28 / 390) * _width,
                              right: (28 / 390) * _width,
                            ),
                            child: Container(
                              height: (33 / 844) * _height,
                              width: (80 / 390) * _width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: secondary,
                                    width: (1 / 390) * _width),
                                borderRadius:
                                    BorderRadius.circular((43 / 390) * _width),
                              ),
                              child: Text(
                                'Log out',
                                style: TextStyle(
                                    color: secondary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: (16 / 844) * _height,
                                    fontFamily: 'sfprorounded'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ));
        });
  }
}
