//dart
import 'dart:io' show Platform;

//plugin
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swol/main.dart';

//STATUS can be everything except GRANTED
//the pop up that called this function is currently open
onAllow(PermissionStatus status, Function onComplete) async {
  if (Platform.isAndroid) {
    //permission status can be
    //1. uknown 2. denied 3. neverAskAgain
  } else if (Platform.isIOS) {
    //permission status can be
    //1. unknown 2. denied 3. restricted

    //IOS only
    //status here is either denied or unknown
    bool permissionGiven = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    //if they didn't grant the permission tell them where to enable it if they change their mind
    if (permissionGiven == false) {
      //TODO: indicate where someone could enable the permission
      //TODO: if they change their mind and if notificationRequested is false
      //because its the first time this has been requested
      //and therefore the user didnt get the pop up from tapping the button
    }
  }
}
