import 'package:flutter/material.dart';
import 'color_constants.dart';

class Utils {

  static void displaySnackBar(BuildContext context, String message, int sec) {
    final snackBar = SnackBar(
        content: Text(
          message,
          style: TextStyle(color: ColorConstants.whiteColor),
        ),
        backgroundColor: ColorConstants.blackColor,
        duration: Duration(seconds: sec));

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static bool isNumeric(String str) {
    if(str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }


}