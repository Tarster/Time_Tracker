import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final Widget child;
  final Color buttonColor;
  final double borderRadius;
  final VoidCallback onPressed;
  final double height;

  CustomRaisedButton(
      {this.height: 50,
      this.buttonColor: Colors.white70,
      required this.child,
      required this.borderRadius,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: ElevatedButton(
          child: child,
          onPressed: onPressed,
          //_googleSignIn,
          style: ElevatedButton.styleFrom(
            primary: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
