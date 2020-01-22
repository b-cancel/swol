//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';

//function
showLearnPopUp(
  BuildContext context,
  Widget header,
  List<Widget> children,
  {
    bool isDense: false,
    bool iconPadding: true,
  }){
  //unfocus so whatever was focused before doesnt annoying scroll us back
  //for some reason this only happens in addExcercise 
  //when opening popups for name, notes, link, and recovery time
  //still its annoying and hence must die
  FocusScope.of(context).unfocus();

  //show the pop up
  AwesomeDialog( 
    context: context,
    isDense: isDense,
    dismissOnTouchOutside: true,
    animType: AnimType.SCALE,
    customHeader: ClipOval(
      child: Container(
        color: iconPadding ? Colors.blue : Colors.white,
        //NOTE: 28 is the max
        padding: EdgeInsets.all(iconPadding ? 24 : 0),
        child: FittedBox(
          fit: BoxFit.fill,
          child: header,
        ),
      ),
    ),
    body: Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    ),
  ).show();
}