import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/widgets/complex/excerciseListTile/miniTimer/wrapper.dart';

//TODO: this timer should automatically close and perform the action if the right ammount of timer has passed
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
    customHeader: Theme(
      data: MyTheme.dark,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Container(
          height: 128,
          width: 128,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          //NOTE: 28 is the max
          padding: EdgeInsets.all(0),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Transform.translate(
              offset: Offset(0,2),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: AnimatedMiniNormalTimer(
                  excercise: excercise,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    body: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            bottom: 16.0,
          ),
          child: Text(
            "Skip Timer",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ),
        Text("yada yada, yoda yoda"),
        Transform.translate(
          offset: Offset(0, 16),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
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
                    "Don't Skip",
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
                    ifSkip();
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ).show();
}
