//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:flushbar/flushbar.dart';

//standard UI
//used by 1. name when only 1 is editable at a time to tell users then need a name (should barely ever happen)
//used by 2. one rep max chip (chips stacking no big deal)
//used by 3. used by reference link to tell the user the link navigation didnt work
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
    borderColor: Theme.of(context).primaryColor,
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