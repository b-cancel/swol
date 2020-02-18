//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';

//function
showCustomPopUp(
  BuildContext context,
  List<Widget> children,
  Widget header, {
  AnimType animationType: AnimType.BOTTOMSLIDE,
  bool isDense: false,
  Color color: Colors.blue,
}) {
  //unfocus so whatever was focused before doesnt annoying scroll us back
  //for some reason this only happens in addExcercise
  //when opening popups for name, notes, link, and recovery time
  //still its annoying and hence must die
  FocusScope.of(context).unfocus(); 

  //show pop up
  AwesomeDialog(
    context: context,
    isDense: isDense,
    dismissOnTouchOutside: true,
    animType: animationType,
    customHeader: FittedBox(
      fit: BoxFit.contain,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        //NOTE: 28 is the max
        padding: EdgeInsets.all(24),
        child: Container(
          width: 56,
          height: 56,
          child: FittedBox(
            fit: BoxFit.fill,
            child: header,
          ),
        ),
      ),
    ),
    body: Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    ),
  ).show();
}
