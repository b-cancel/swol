//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';

//internal
import 'package:swol/shared/widgets/simple/ourHeaderIconPopUp.dart';

//functions
numberSuffix(int aNum) {
  if (aNum == 1 || aNum == 21 || aNum == 31)
    return "st";
  else if (aNum == 2 || aNum == 22 || aNum == 32)
    return "nd";
  else if (aNum == 3 || aNum == 23 || aNum == 33)
    return "rd";
  else
    return "th";
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
  showBasicHeaderIconPopUp(
    context,
    [
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
          horizontal: 16.0,
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
    DialogType.WARNING,
    animationType: AnimType.BOTTOMSLIDE,
    clearBtn: FlatButton(
      child: Text(
        "Finished",
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    colorBtn: RaisedButton(
      child: Text(
        "Do Another Set",
      ),
      onPressed: () {
        //pop ourselves
        Navigator.pop(context);

        //proceed as expected
        ifMovePast();
      },
    ),
  );
}
