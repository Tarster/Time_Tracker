import 'package:flutter/material.dart';
import 'package:time_tracker_final/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton(
      {required String text,
      required Color textColor,
      required Color buttonColor,
      required VoidCallback onPressed})
      : super(
            borderRadius: 10,
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 15.0,
              ),
            ),
            onPressed: onPressed,
            buttonColor: buttonColor);
}
