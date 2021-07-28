import 'package:flutter/material.dart';
import 'package:time_tracker_final/common_widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    required String text,
    required Color textColor,
    required Color buttonColor,
    required VoidCallback onPressed,
    required String imageName,
  }) : super(
            borderRadius: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset(imageName),
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15.0,
                  ),
                ),
                Opacity(
                  opacity: 0,
                  child: Image.asset(imageName),
                ),
              ],
            ),
            onPressed: onPressed,
            buttonColor: buttonColor);
}
