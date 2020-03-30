//dart
import 'dart:io' show Platform;

//plugin
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

//internal
import 'package:swol/action/buttonLocationPopUp.dart';
import 'package:swol/action/restrictedPopUp.dart';
import 'package:swol/action/appSettingsPopUp.dart';
import 'package:swol/main.dart';

//NOTE: according to "https://pub.dev/packages/notification_permissions"

//DEFAULT STATE
//In iOS, a permission is unknown when the user hasn’t accepted or refuse the notification permissions. 
//In Android this state will never occur, 
//  since the permission will be granted by default 
//  and it will be denied if the user goes to the app settings and turns off notifications for the app.

//ACTION
//In iOS, if the permission is unknown, it will show an alert window asking the user for the permission. 
//  On the other hand, if the permission is denied it has the same behaviour as Android, opening the app settings
//On Android, if the permission is denied, this method will open the app settings.

//STATUS can be everything except GRANTED
onAllow(
  PermissionStatus status,
  Function onComplete,
  bool automaticallyOpened,
) async {
  //according to android documentation, the status initially is always going to be denied
  //im going to assume unknown is also a part of that becuase frankly I'm not aware when unknown comes up
  //it might be an exclusively IOS problem
  if (Platform.isAndroid) {
    //permission status can be
    //1. unknown 2. denied 3. neverAskAgain
    //but actually... because this is the notification permission...
    //and its automatically granted... no pop up exists
    //so regardless of the status
    //which according to Android will 
    //ATLEAST not be unknown (since this is an IOS only thing)
    //we will be brining up the AppSettings pop up

    requestThatYouGoToAppSettings(
      status, 
      onComplete, 
      automaticallyOpened,
    );
  } else if (Platform.isIOS) {
    //permission status can be
    //1. unknown 2. denied 3. restricted
    if (status == PermissionStatus.restricted) {
      showRestrictedPopUp(
        status, 
        onComplete,
        automaticallyOpened,
      );
    } else {
      //IF it hasn't been requested before its going to be unknown
      //IF it has been requested before but it was denied it will be denied
      bool permissionGiven = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      //TODO: figure out what happens if the user rejects ONE of these
      //does permissionGiven get returned as false

      //if they didn't grant the permission tell them where to enable it if they change their mind
      //only if they didn't open it through the button
      if(permissionGiven){
        //they did what we expected, so we continue
        onComplete();
      }
      else{
        //inform them of where they can change their mind
        maybeShowButtonLocation(
          status,
          onComplete,
          automaticallyOpened,
        );
      }
    }
  }
}
