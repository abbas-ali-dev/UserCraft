import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toaster {
  static Future<void> showToast(String message) async {
    Fluttertoast.showToast(
      msg: message,
      timeInSecForIosWeb: 3,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.white,
      gravity: ToastGravity.TOP,
      backgroundColor: Color(0XFFffd21f),
      // webBgColor: Color(0XFF7DBD2C),
    );
  }
}
