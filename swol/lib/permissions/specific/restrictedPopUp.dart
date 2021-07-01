//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:permission_handler/permission_handler.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

//internal
import 'package:swol/shared/widgets/simple/ourHeaderIconPopUp.dart';
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
  //function
  Function onDeny = () {
    //make sure the user knows where they can re-enable
    //if they didnt already get here from pressing the button

    //TODO: un comment below
    /*
    maybeShowButtonLocation(
      status,
      onComplete,
      automaticallyOpened,
    );
    */
  };

  BuildContext? globalBuildContext = ExercisePage.globalKey.currentContext;

  if (globalBuildContext != null) {
    //pop up
    showBasicHeaderIconPopUp(
      globalBuildContext,
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
                  globalBuildContext,
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
            ],
          ),
        ),
      ],
      DialogType.ERROR,
      dismissOnTouchOutside: automaticallyOpened == false,
      //animationType: null,
      clearBtn: WillPopScope(
        onWillPop: () async {
          //negative action
          onDeny();

          //allow pop
          return true;
        },
        child: TextButton(
          child: new Text("I'll do it later"),
          onPressed: () {
            //pop ourselves
            Navigator.of(
              globalBuildContext,
            ).pop();

            //show button if needed
            onDeny();
          },
        ),
      ),
      colorBtn: ElevatedButton(
        child: Text("Try Again"),
        onPressed: () async {
          //maybe the user made the required change
          //check again
          PermissionStatus status = await Permission.notification.status;

          //pop ourselves
          Navigator.of(
            globalBuildContext,
          ).pop();

          //the user wants to allow
          //but now handle all the different ways
          //we MIGHT have to go about that
          //TODO: un comment below
          /*
          onAllow(
            status,
            onComplete,
            automaticallyOpened,
          );
          */
        },
      ),
    );
  }
}
