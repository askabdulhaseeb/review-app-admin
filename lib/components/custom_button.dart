import 'package:admin_review/utils/color_constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final String buttonText;
  final VoidCallback callback;

  CustomButton(this.buttonText, this.callback);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

        callback();

      },
      child: Container(
        height: 50.0,
        color: Colors.transparent,
        child: Container(
            decoration: BoxDecoration(
                color: ColorConstants.continueButtonColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(32.0),
                )),
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                    color: ColorConstants.whiteColor, fontSize: 18),
              ),
            )),
      ),
    );
  }
}
