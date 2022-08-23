// ignore: import_of_legacy_library_into_null_safe
import 'package:flushbar/flushbar.dart';
import "package:flutter/material.dart";

notifySuccess(
  context, {
  String title = "Success!",
  String message: "The action was completed successfully.",
}) {
  Flushbar(
    title: title,
    icon: Icon(
      Icons.done,
      color: Colors.white,
      size: 26,
    ),
    flushbarPosition: FlushbarPosition.TOP,
    margin: EdgeInsets.all(8),
    borderRadius: 8,
    barBlur: 2,
    backgroundColor: Color.fromRGBO(46, 159, 84, 0.9),
    message: message,
    duration: Duration(seconds: 3),
  )..show(context);
}

notifyError(
  context, {
  String title = "Error!",
  String message: "Something went wrong!",
}) {
  Flushbar(
    icon: Icon(
      Icons.error_outline,
      color: Colors.white,
      size: 26,
    ),
    title: title,
    flushbarPosition: FlushbarPosition.TOP,
    margin: EdgeInsets.all(8),
    borderRadius: 8,
    barBlur: 2,
    backgroundColor: Color.fromRGBO(247, 54, 54, 0.9),
    message: message,
    duration: Duration(seconds: 3),
  )..show(context);
}

notifyConnectionError(
  context, {
  String title = "No internet connection!",
  String message: "Please, check your internet connection!",
}) {
  Flushbar(
    icon: Icon(
      Icons.error_outline,
      color: Colors.white,
      size: 26,
    ),
    title: title,
    flushbarPosition: FlushbarPosition.TOP,
    margin: EdgeInsets.all(8),
    borderRadius: 8,
    barBlur: 2,
    backgroundColor: Color.fromRGBO(247, 54, 54, 0.9),
    message: message,
    duration: Duration(seconds: 3),
  )..show(context);
}
