import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fora_business/common/components/flush.dart';
import 'package:fora_business/common/components/pin-code-auth.dart';
import 'package:fora_business/common/constants.dart';
import 'package:fora_business/data_models/current-user-type.dart';
import 'package:fora_business/view_models/auth-model.dart';
import 'package:fora_business/views/navigations-view-new.dart';
import 'package:fora_business/views/sign-in-view.dart';
import 'package:http/http.dart' as http;
// ignore: import_of_legacy_library_into_null_safe
import 'package:momentum/momentum.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/components/new-password-sheet.dart';

class AuthController extends MomentumController<AuthModel> {
  @override
  AuthModel init() {
    return AuthModel(
      this,
      email: '',
      currentUser: null,
    );
  }

  void changeBirthDate(String birthDate) async {
    model.update(birthDate: birthDate);
  }

  Future<void> changeLocation(String location, context) async {
    model.update(area: location);
    var url = Uri.https(STAGING_URL, "/api/v1/users/me");
    var response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${model.currentUser.accessToken}'
      },
      body: jsonEncode(<String, String>{
        'area': location.toLowerCase(),
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      model.update(
        area: jsonResponse['user']['area'],
      );
    } else {
      model.update(surveyInProgress: false);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      notifyError(context, message: jsonResponse['message']);

      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> getUserWallet() async {
    var url = Uri.https(STAGING_URL, "/api/v1/users/me/wallet");
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${model.currentUser.accessToken}'
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      model.update(wallet: jsonResponse['wallet']['amount']);
    } else {}
  }

  Future<void> changeNotifcationSwitch(bool switcher, context) async {
    print('suppose:');
    print(switcher);
    var url = Uri.https(STAGING_URL, "/api/v1/users/me");
    var response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${model.currentUser.accessToken}'
      },
      body: jsonEncode(<String, bool>{'isNotificationEnabled': switcher}),
    );
    print("notifications:");
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      model.update(
        isNotificationEnabled: jsonResponse['user']['isNotificationEnabled'],
      );
    } else {
      model.update(surveyInProgress: false);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      notifyError(context, message: jsonResponse['message']);

      print('Request failed with status: ${response.statusCode}.');
    }
  }

// Navigate to login options page
  void goToLoginPage(context) {}

  void goToHomePage(context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => NavigationBarViewNew(), fullscreenDialog: true),
    );
  }

  Future<void> handleAppBoot(context, fromSplash,
      {fromSurveyOrLogin = false}) async {
    debugPrint("In handle app boot");
    debugPrint("isPhoneVerified: ${model.currentUser.isPhoneVerified}");
    debugPrint("Phone number: ${model.currentUser.phoneNumber}");
    if (model?.currentUser?.accessToken != null) {
      if (true) {
        Navigator.of(context).pop();
        goToHomePage(context);
      } else {
        notifyError(
          context,
          title: "📣Attention athlete",
          message: "Please verify your phone number to start competing🏆",
        );
        // Ask user to verify phone number
        if (fromSurveyOrLogin) {
          Momentum.controller<AuthController>(context)
              .handleSendCodeForPhoneVerification(
            "+2" + model.currentUser.phoneNumber,
            context,
          );
        }
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return PinCodeVerificationScreen(
              phoneNumber: model.currentUser.phoneNumber,
              verifyingPhoneNumber: true,
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                (25.0),
              ),
            ),
          ),
        );
      }
    } else {
      goToLoginPage(context);
    }
  }

  validateEmailLogin(String email, String password) {
    var result = {"valid": false, "error": ""};
    if (email.length > 0) {
      if (password.length > 0) {
        result["valid"] = true;
      } else {
        result["error"] = "The password field cannot be empty!";
      }
    } else {
      result["error"] = "The email field cannot be empty!";
    }
    return result;
  }

  validateEmailSignUp(
      String firstName, String lastName, String email, String password) {
    var result = {"valid": false, "error": ""};
    if (firstName.length > 0) {
      if (lastName.length > 0) {
        if (email.length > 0) {
          if (password.length > 0) {
            result["valid"] = true;
          } else {
            result["error"] = "The password field cannot be empty!";
          }
        } else {
          result["error"] = "The email field cannot be empty!";
        }
      } else {
        result["error"] = "The lastname field cannot be empty!";
      }
    } else {
      result["error"] = "The firstname field cannot be empty!";
    }

    return result;
  }

// handle the login via email
  void handleEmailLogin(email, password, context) async {
    final validation = validateEmailLogin(email, password);
    if (validation["valid"]) {
      model.update(
        loginInProgress: true,
      );
      var url = Uri.https(STAGING_URL, "/api/v1/users/login");
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            <String, String>{'emailOrPhone': email, 'password': password}),
      );
      debugPrint("LOGIN RESPONSE:  ${response.body}");
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        print(jsonResponse['user']['location']);
        model.update(
          currentUser: CurrentUserType(
            id: jsonResponse['user']['_id'],
            accessToken: jsonResponse['token'],
            firstName: jsonResponse['user']['firstName'],
            lastName: jsonResponse['user']['lastName'],
            phoneNumber: jsonResponse['user']['phone'],
            isNotificationEnabled: jsonResponse['user']
                ['isNotificationEnabled'],
            area: jsonResponse['user']['area'],
            isPhoneVerified: jsonResponse['user']['isPhoneVerified'],
          ),
          email: jsonResponse['user']['email'],
          area: jsonResponse['user']['area'],
          isNotificationEnabled: jsonResponse['user']['isNotificationEnabled'],
          loginInProgress: true,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
          'token',
          jsonResponse['token'],
        );
        model.update(loginInProgress: false);
        handleAppBoot(context, false, fromSurveyOrLogin: true);
      } else {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        model.update(loginInProgress: false);

        notifyError(context, message: jsonResponse['message']);

        print('Request failed with status: ${response.statusCode}.');
      }
    } else {}
  }

  void handleDeleteUserAccount(context) async {
    var url = Uri.https(STAGING_URL, "/api/v1/users/me");
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${model.currentUser.accessToken}'
      },
    );
    print(response.body);
    print(model.currentUser.accessToken);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => SignIn(
              triggerLogoutEvent: true,
            ),
          ),
          (Route<dynamic> route) => false);

      notifySuccess(context);
    } else {
      notifyError(context);
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> getCurrentUserByToken(token, context) async {
    var url = Uri.https(STAGING_URL, "/api/v1/users/me");
    // TODO we need to get the fcmToken
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    debugPrint("getCurrentUserByToken RESPONSE:  ${response.body}");
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      model.update(
        currentUser: CurrentUserType(
          id: jsonResponse['user']['_id'],
          accessToken: token,
          firstName: jsonResponse['user']['firstName'],
          lastName: jsonResponse['user']['lastName'],
          phoneNumber: jsonResponse['user']['phone'],
          gender: jsonResponse['user']['gender'],
          birthDate: jsonResponse['user']['birthDate'],
          favoriteSport: jsonResponse['user']['favoriteSport'],
          area: jsonResponse['user']['area'],
          isPhoneVerified: jsonResponse['user']['isPhoneVerified'],
        ),
        email: jsonResponse['user']['email'],
        area: jsonResponse['user']['area'],
        isNotificationEnabled: jsonResponse['user']['isNotificationEnabled'],
      );
      model.update(verified: true);

      handleAppBoot(context, false);
    } else {
      model.update(surveyInProgress: false);
      print('Request failed with status: ${response.statusCode}.');
      Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => SignIn(), fullscreenDialog: true),
      );
      model.update(verified: false);
    }
  }

  // handles the phone number verification
  void handleSendCodeForPhoneVerification(phoneNumber, context) async {
    var url = Uri.https(STAGING_URL, "/api/v1/users/send-verification/phone");

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${model.currentUser.accessToken}'
      },
    );
    print(response.body);
    if (response.statusCode != 200) {
      model.update(signUpInProgress: false);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      notifyError(context, message: jsonResponse['message']);
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void handleVerifyCodePhoneNumberVerification(
      code, phoneNumber, context) async {
    var url = Uri.https(STAGING_URL, "/api/v1/users/verify/phone");
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${model.currentUser.accessToken}'
      },
      body: jsonEncode(<String, String>{'code': code}),
    );
    debugPrint("Respone body: ${response.body}");
    if (response.statusCode == 200) {
      debugPrint("Is phone verified? ${model.currentUser.isPhoneVerified}");
      model.update(
        currentUser: CurrentUserType(
          id: model.currentUser.id,
          accessToken: model.currentUser.accessToken,
          firstName: model.currentUser.firstName,
          lastName: model.currentUser.lastName,
          phoneNumber: model.currentUser.phoneNumber,
          gender: model.currentUser.gender,
          birthDate: model.currentUser.birthDate,
          favoriteSport: model.currentUser.favoriteSport,
          area: model.currentUser.area,
          isPhoneVerified: true,
        ),
      );
      debugPrint("Is phone verified? ${model.currentUser.isPhoneVerified}");
      notifySuccess(context);
      goToHomePage(context);
    } else {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      notifyError(context, message: jsonResponse['message']);
      print('Request failed with status: ${response.statusCode}.');
      goToLoginPage(context);
    }
  }

  // handles the forgot password logic
  void handleSendCodeUsingPhoneNumber(phoneNumber, bool resend, context) async {
    model.update(
      forgotPasswordInProgress: true,
    );
    var url = Uri.https(STAGING_URL, "/api/v1/users/send-password-reset-code");
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'phone': phoneNumber,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      notifySuccess(context, message: jsonResponse['message']);
      if (!resend)
        showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return PinCodeVerificationScreen(
                phoneNumber: phoneNumber,
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  (25.0),
                ),
              ),
            ));
    } else {
      model.update(signUpInProgress: false);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      notifyError(context, message: jsonResponse['message']);
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void handleVerifyCodeUsingPhoneNumber(code, phoneNumber, context) async {
    model.update(
      forgotPasswordInProgress: true,
    );
    var url =
        Uri.https(STAGING_URL, "/api/v1/users/verify/password-reset-code");
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'code': code,
        'phone': phoneNumber,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      model.update(
        changePasswordTempToken: jsonResponse["token"],
      );
      print(model.changePasswordTempToken);
      notifySuccess(
        context,
      );
      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return NewPasswordViewSheet();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                (25.0),
              ),
            ),
          ));
    } else {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      notifyError(context, message: jsonResponse['message']);
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void handleChangePasswordUsingPhoneNumber(
      newPassword, confirmNewPassword, context) async {
    model.update(
      forgotPasswordInProgress: true,
    );
    var url = Uri.https(STAGING_URL, "/api/v1/users/forget-password");
    var tempToken = model.changePasswordTempToken;
    print('token:');
    print(tempToken);
    print(newPassword);
    print(confirmNewPassword);
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'token': tempToken,
        'password': newPassword,
        'confirmPassword': confirmNewPassword,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      model.update(
        changePasswordTempToken: jsonResponse["token"],
      );
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      notifySuccess(context, message: jsonResponse['message']);
    } else {
      model.update(signUpInProgress: false);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      notifyError(context, message: jsonResponse['message']);
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void handleUserChangePassword(
      currentPassword, newPassword, confirmNewPassword, context) async {
    var url = Uri.https(STAGING_URL, "/api/v1/users/change-password");
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${model.currentUser.accessToken}',
      },
      body: jsonEncode(<String, String>{
        'password': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmNewPassword,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      Navigator.of(context).pop();
      notifySuccess(context, message: jsonResponse['message']);
    } else {
      model.update(signUpInProgress: false);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      notifyError(context, message: jsonResponse['message']);
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  CurrentUserType getCurrentUser() {
    return model.currentUser;
  }

  Future<void> checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.wifi) {
      print('Connected to a Wi-Fi network');
    } else if (result == ConnectivityResult.mobile) {
      print('Connected to a mobile network');
    } else {
      print('Not connected to any network');
    }
    model.update(connectionType: result);
  }

  Future<void> tryConnection() async {
    try {
      model.update(hasInternet: true);
    } on SocketException catch (e) {
      print(e);
      model.update(hasInternet: false);
    }
  }
}
