import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:swol/action/popUps/button.dart';

numberSuffix(int aNum){
    if(aNum == 1 || aNum == 21 || aNum == 31) return "st";
    else if(aNum == 2 || aNum == 22 || aNum == 32) return "nd";
    else if (aNum == 3 || aNum == 23 || aNum == 33) return "rd";
    else return "th";
  }

movePastSetTarget(
  BuildContext context,
  Function ifMovePast,
  int setTarget,
  Color headerColor,
) {
  //reused everywhere
  TextStyle bold = TextStyle(
    fontWeight: FontWeight.bold,
  );

  int nextSet = (setTarget + 1);
  String suffix = numberSuffix(nextSet);

  //show the dialog
  AwesomeDialog(
    context: context,
    isDense: false,
    //NOTE: on dimiss nothing except dismissing the dialog happens
    dismissOnTouchOutside: true,
    animType: AnimType.BOTTOMSLIDE,
    dialogType: DialogType.WARNING,
    headerAnimationLoop: false,
    body: Column(
      children: <Widget>[
        Text(
          "Move Past Set Target?",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "\nYour planned to only do ",
                  ),
                  TextSpan(
                    text: setTarget.toString(),
                    style: bold,
                  ),
                  TextSpan(
                    text: " sets\n\n",
                  ),
                  TextSpan(
                    text: "You can move onto your ",
                  ),
                  TextSpan(
                    text: nextSet.toString() + suffix,
                    style: bold,
                  ),
                  TextSpan(
                    text: " and update your set target when you are finished",
                  )
                ],
              ),
            ),
            ],
          ),
        ),
      ],
    ),
    btnCancel: AwesomeButton(
      clear: true,
      child: Text(
        "Finished",
      ),
      onTap: () {
        Navigator.pop(context);
      },
    ),
    btnOk: AwesomeButton(
      child: Text(
        "Do Another Set",
      ),
      onTap: () {
        //pop ourselves
        Navigator.pop(context);

        //proceed as expected
        ifMovePast();
      },
    ),
  ).show();
}
