import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:swol/shared/methods/theme.dart';
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
            Transform.translate(
              offset: Offset(0, 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Keep Going",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      //pop ourselves
                      Navigator.pop(context);

                      //proceed as expected
                      ifFinish();
                    },
                    child: Text(
                      "Finish Excercise",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        )
      ],
    ),
  ).show();
}