//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:flushbar/flushbar.dart';

//standard UI
openSnackBar(
  BuildContext context, 
  String message, 
  Color color, 
  IconData icon,
){
  Flushbar(
    message: message,
    shouldIconPulse: false,
    isDismissible: true,
    dismissDirection: FlushbarDismissDirection.VERTICAL,
    icon: Icon(
      icon,
      size: 28.0,
      color: color,
    ),
    onTap: (_){
      Navigator.of(context).pop();
    },
    duration: Duration(seconds: 3),
    leftBarIndicatorColor: color,
    flushbarPosition: FlushbarPosition.BOTTOM,
    flushbarStyle: FlushbarStyle.FLOATING,
    margin: EdgeInsets.all(16), 
  )..show(context);
}