//dart
import 'dart:io' show Platform;

//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

//internal
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'package:swol/shared/widgets/simple/playOnceGif.dart';
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/main.dart';

//we only care to tell the user where the button is when they deny
//if they don't already know
//so we check if we are on the page with the button to determine if we should show the pop up
maybeShowButtonLocation(
  BuildContext context, 
  PermissionStatus status,
  //on complete HAS TO RUN
  //regardless of what pop up path the user takes 
  Function onComplete) async{
  showDialog(
    context: context,
    //the user MUST respond
    barrierDismissible: false,
    //show pop up
    builder: (BuildContext context) {
      return Theme(
        data: MyTheme.light,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          contentPadding: EdgeInsets.all(0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.0),
                  topLeft: Radius.circular(12.0),
                ),
                child: Container(
                  color: Colors.red,
                  width: MediaQuery.of(context).size.width,
                  height: 128,
                  padding: EdgeInsets.all(24),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Container(
                      child: Icon(
                        Icons.clear,
                        color: Colors.white,
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
                    Text(
                      "Grant Us Access",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    Text(
                      "To Send Notifications",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
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
                              text: "It's important that you recover",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " before moving onto your next set.\n\n",
                            ),
                            TextSpan(
                              text: "But "
                            ),
                            TextSpan(
                              text: "it's not fun to have to wait ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "for the clock to tick down.\n\n"
                            ),
                            TextSpan(
                              text: "If you grant us access to send notifications, ",
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
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text("Deny"),
              onPressed: () {
                //notification
                Navigator.of(context).pop();

                //TODO: indicate where someone could enable the permission 
                //TODO: if they change their mind and if notificationRequested is false
                //because its the first time this has been requested
                //and therefore the user didnt get the pop up from tapping the button
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 8.0,
              ),
              child: RaisedButton(
                child: Text("Allow"),
                color: Theme.of(context).accentColor,
                onPressed: () async{
                  //remove this pop up to show the IOS pop up
                  Navigator.of(context).pop();

                  //If android its only posible for you to enable it manually through settings
                  if (Platform.isAndroid) { 

                  } else if (Platform.isIOS) {
                    //IOS only
                    //status here is either denied or unknown
                    bool permissionGiven = await flutterLocalNotificationsPlugin
                    .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
                    ?.requestPermissions(
                      alert: true,
                      badge: true,
                      sound: true,
                    );

                    //if they didn't grant the permission tell them where to enable it if they change their mind
                    if(permissionGiven == false){
                      //TODO: indicate where someone could enable the permission 
                      //TODO: if they change their mind and if notificationRequested is false
                      //because its the first time this has been requested
                      //and therefore the user didnt get the pop up from tapping the button
                    }
                  }
                },
              ),
            )
          ],
        ),
      );
    },
  );
}