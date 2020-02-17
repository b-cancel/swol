import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/widgets/complex/excerciseListTile/miniTimer/wrapper.dart';

maybeSkipTimer(BuildContext context, AnExcercise excercise, Function ifSkip) {
  //remove focus so the pop up doesnt bring it back
  FocusScope.of(context).unfocus();

  //show the dialog
  AwesomeDialog(
    context: context,
    isDense: false,
    //NOTE: on dimiss nothing except dismissing the dialog happens
    dismissOnTouchOutside: true,
    animType: AnimType.TOPSLIDE,
    customHeader: AnimatedMiniNormalTimer(
      excercise: excercise,
    ),
    body: Container(
      child: Text("body or something"),
    ),
  ).show();
}
