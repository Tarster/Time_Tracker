import 'package:flutter/material.dart';
import 'package:time_tracker_final/common_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton{
  FormSubmitButton({
    required String text,
    required VoidCallback? onPressed
}) : super (
    borderRadius: 10,
    child: Text(text, style: TextStyle(color: Colors.white,fontSize: 20.0 ),),
    height: 44.0,
  buttonColor: Colors.teal,
  onPressed: onPressed);
}