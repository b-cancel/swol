//flutter
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//plugin
import 'package:permission_handler/permission_handler.dart';
import 'package:swol/main.dart';

//internal
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/widgets/simple/playOnceGif.dart';

/*
Release build configuration #
When doing a release build of your app, which is the default setting when building an APK or 
app bundle, you'll likely need to customise your ProGuard configuration file as per this 
link and add the following line.

-keep class com.dexterous.** { *; }
The plugin also makes use of GSON and the Proguard rules can be found here. The example app 
has a consolidated Proguard rules (proguard-rules.pro) file that combines these together 
for reference here.

You will also need to ensure that you have configured the resources that should be kept 
so that resources like your notification icons aren't discarded by the R8 compiler by 
following the instructions here. Without doing this, you might not see the icon you've 
specified in your app's notifications. The configuration used by the example app can be 
found here where it is specifying that all drawable resources should be kept, as well as 
the file used to play a custom notification sound (sound file is located here).

IMPORTANT: Starting from version 0.5.0, this library no longer uses the deprecated 
Android support libraries and has migrated to AndroidX. Developers may require 
migrating their apps to support this following this guide
*/

//requestor
//NOTE: here status is NOT granted and NOT restricted
//but could be anything else
requestNotificationPermission(
  BuildContext context, 
  PermissionStatus status, 
  Function onComplete) async{
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // return object of type Dialog
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
                Navigator.of(context).pop();

                //TODO: indicate where someone could enable the permission if they change their mind
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
                    //TODO: indicate where someone could enable the permission if they change their mind
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

/*requestThatYouGoToAppSettings(
  BuildContext context, 
  Function onComplete) async{
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // return object of type Dialog
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
                Navigator.of(context).pop();
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 8.0,
              ),
              child: RaisedButton(
                child: Text("Go To App Settings"),
                color: Theme.of(context).accentColor,
                onPressed: (){
                  if(status == PermissionStatus.neverAskAgain){
                    Navigator.of(context).pop();
                  }
                  else{ //must be denied

                  }
                },
              ),
            )
          ],
        ),
      );
    },
  );
}*/