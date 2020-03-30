//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:permission_handler/permission_handler.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

//internal
import 'package:swol/shared/widgets/simple/ourHeaderIconPopUp.dart';
import 'package:swol/action/buttonLocationPopUp.dart';
import 'package:swol/action/ifAllow.dart';
import 'package:swol/action/page.dart';

//we only care to tell the user where the button is when they deny
//if they don't already know
//so we check if we are on the page with the button to determine if we should show the pop up
showRestrictedPopUp(
  PermissionStatus status,
  //on complete HAS TO RUN
  //regardless of what pop up path the user takes
  Function onComplete,
  bool automaticallyOpened,
) async {
  showBasicHeaderIconPopUp(
    ExercisePage.globalKey.currentContext,
    [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.contain,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "You Are Restricted",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      "from granting us access",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 24,
              ),
              child: RichText(
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
                    TextSpan(
                        text:
                            " isn't going to allow you to grant us access.\n\n"),
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
            ),
          ],
        ),
      ),
    ],
    DialogType.ERROR,
    dismissOnTouchOutside: false,
    clearBtn: FlatButton(
      child: new Text("I'll do it later"),
      onPressed: () {
        //pop ourselves
        Navigator.of(
          ExercisePage.globalKey.currentContext,
        ).pop();

        //make sure the user knows where the button is
        //will always call on complete
        maybeShowButtonLocation(
          status,
          onComplete,
          automaticallyOpened,
        );
      },
    ),
    colorBtn: RaisedButton(
      child: Text("Try Again"),
      onPressed: () async {
        //maybe the user made the required change
        //check again
        PermissionStatus status =
            await PermissionHandler().checkPermissionStatus(
          PermissionGroup.notification,
        );

        //pop ourselves
        Navigator.of(
          ExercisePage.globalKey.currentContext,
        ).pop();

        //the user wants to allow
        //but now handle all the different ways
        //we MIGHT have to go about that
        onAllow(
          status,
          onComplete,
          automaticallyOpened,
        );
      },
    ),
  );
}
