//returns true if granted, false if not
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swol/action/page.dart';
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/widgets/simple/playOnceGif.dart';
import 'package:swol/shared/widgets/simple/popUpAdjustments.dart';

//requires a seperate shared preferences variable because this permission is granted by default by some systems
//specifically android
//and ios does the same provisionally if you simply schedule a notification without asking first
Future<bool> askForPermissionIfNotGrantedAndWeNeverAsked() async {
  //regardless of whether its been requested before
  //we first check if it needs to be requested
  PermissionStatus status = await Permission.notification.status;

  //they are restricted... don't bother them with knowing that
  if (status == PermissionStatus.restricted) {
    //auto reject
    return false;
  } else {
    //check if we have the permission
    if (status == PermissionStatus.granted ||
        status == PermissionStatus.limited) {
      //auto accept
      return true;
    } else {
      //access not granted & we already asked them directly
      if (SharedPrefsExt.getNotificationRequested().value) {
        return false;
      } else {
        //access not granted & we HAVE NOT already asked them directly
        return await requestNotificationPermission(
          automaticallyOpened: true,
        );
      }
    }
  }
}

Future<bool> requestNotificationPermission({
  required bool automaticallyOpened,
}) async {
  BuildContext? context = ExercisePage.globalKey.currentContext;
  if (context == null) {
    return false;
  } else {
    SharedPrefsExt.setNotificationRequested(true);
    bool willAllow = await explainNotificationPermission(
      context,
      automaticallyOpened: automaticallyOpened,
    );

    //TODO: you know they will allow now actually ask them
    return willAllow;

    /*
  //functions
    Function onDeny = () {
      //make sure the user knows where the button is
      //will always call on complete
      maybeShowButtonLocation(
        status,
        onComplete,
        automaticallyOpened,
      );
    };
  */
    /*
  onAllow(
                                status,
                                onComplete,
                                automaticallyOpened,
                              );
  */
  }
}

//true if allow
//false if deny
Future<bool> explainNotificationPermission(
  BuildContext context, {
  required bool automaticallyOpened,
}) async {
  return await showDialog(
    context: context,
    //the user MUST respond
    barrierDismissible: false,
    //show pop up
    builder: (BuildContext context) {
      //convert the pop ups that appear after this one closes into light ones
      //primarily for scenarios where you have the icon pop ups
      return Theme(
        data: MyTheme.light,
        child: WillPopScope(
          //the user MUST respond
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            contentPadding: EdgeInsets.all(0),
            content: ScrollViewWithShadow(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.0),
                      topLeft: Radius.circular(12.0),
                    ),
                    child: Container(
                      color: Theme.of(context).accentColor,
                      child: Center(
                        child: Container(
                          width: 128,
                          height: 128,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: PlayGifOnce(
                              assetName: "assets/notification/blueShadow.gif",
                              frameCount: 125,
                              runTimeMS: 2500,
                              colorWhite: false,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TitleThatContainsTRBL(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "To Be Notified",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                ),
                              ),
                              Text(
                                "When Your Break Is Finished",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "Allow Notifications",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                text: "It's important that you recover",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " before moving onto your next set.\n\n",
                              ),
                              TextSpan(text: "But "),
                              TextSpan(
                                text: "it's not fun to have to wait ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: "for the clock to tick down.\n\n"),
                              TextSpan(
                                text:
                                    "If you grant us access to send notifications, ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: "we can alert you",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " when you are ready for you next set.",
                              ),
                            ],
                          ),
                        ),
                        BottomButtonsThatResizeTRBL(
                          secondary: TextButton(
                            child: new Text("Deny"),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          primary: ElevatedButton(
                            child: Text("Allow"),
                            style: ElevatedButton.styleFrom(
                              primary: MyTheme.dark.accentColor,
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
