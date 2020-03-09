import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:swol/action/popUps/button.dart';
import 'package:swol/shared/structs/anExercise.dart';

maybeChangeSetTarget(
  BuildContext context,
  AnExercise exercise,
  Function ifFinish,
  Color headerColor,
) {
  //remove focus so the pop up doesnt bring it back
  FocusScope.of(context).unfocus();

  //reused everywhere
  TextStyle bold = TextStyle(
    fontWeight: FontWeight.bold,
  );

  //show the dialog
  AwesomeDialog(
    context: context,
    isDense: false,
    //NOTE: on dimiss nothing except dismissing the dialog happens
    dismissOnTouchOutside: true,
    animType: AnimType.LEFTSLIDE,
    dialogType: DialogType.WARNING,
    headerAnimationLoop: false,
    body: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            bottom: 16.0,
          ),
          child: Text(
            "Change Set Target?",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //TODO: adjust the message
              /*
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "\nAre you sure you want to ",
                  ),
                  TextSpan(
                    text: "Finish You Workout?",
                    style: bold,
                  ),
                ],
              ),
            ),*/
            ],
          ),
        ),
      ],
    ),
    btnCancel: AwesomeButton(
      clear: true,
      child: Text(
        "Keep Going",
      ),
      onTap: () {
        Navigator.pop(context);
      },
    ),
    btnOk: AwesomeButton(
      child: Text(
        "Finish Excercise",
      ),
      onTap: () {
        //pop ourselves
        Navigator.pop(context);

        //proceed as expected
        ifFinish();
      },
    ),
  ).show();
}
