//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';

//internal
import 'package:swol/shared/widgets/simple/ourHeaderIconPopUp.dart';

//true -> they want to try again
//false -> if they just wana finish and close everything off
showRestrictedPopUp(
  BuildContext context,
) async {
  //pop up
  return showBasicHeaderIconPopUp(
    context,
    [
      Text(
        "You Are Restricted",
        style: TextStyle(
          fontSize: 28,
        ),
      ),
      Text(
        "from granting us access",
        style: TextStyle(
          fontSize: 24,
        ),
      ),
    ],
    [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              textScaleFactor: MediaQuery.of(
                context,
              ).textScaleFactor,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "Parental Controls",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " or a ",
                  ),
                  TextSpan(
                    text: "Security Option",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: " isn't allowing you to grant us access.\n\n"),
                  TextSpan(
                    text: "Remove The Restriction",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: " and Try Again.\n\n"),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
    DialogType.ERROR,
    //for them to make a choice
    dismissOnTouchOutside: false,
    //animationType: null,
    clearBtn: TextButton(
      child: new Text("I'll do it later"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    ),
    colorBtn: ElevatedButton(
      child: Text("Try Again"),
      onPressed: () async {
        Navigator.of(context).pop(true);
      },
    ),
  );
}
