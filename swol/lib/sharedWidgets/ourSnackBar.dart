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
    backgroundColor: Theme.of(context).cardColor,
    borderColor: Theme.of(context).primaryColorDark,
    icon: Icon(
      icon,
      size: 28.0,
      color: color,
    ),
    onTap: (_){
      Navigator.of(context).pop();
    },
    borderRadius: 16,
    duration: Duration(seconds: 3),
    leftBarIndicatorColor: Colors.transparent, //color,
    flushbarPosition: FlushbarPosition.BOTTOM,
    flushbarStyle: FlushbarStyle.FLOATING,
    margin: EdgeInsets.all(16), 
  )..show(context);
}