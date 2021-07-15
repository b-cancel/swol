//returns true if granted, false if not
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swol/action/page.dart';
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'dart:io' show Platform;

import '../../main.dart';
import 'buttonLocationPopUp.dart';
import 'explainWhyPermission.dart';

//requires a seperate shared preferences variable because this permission is granted by default by some systems
//specifically android
//and ios does the same provisionally if you simply schedule a notification without asking first
Future<bool> askForPermissionIfNotGrantedAndWeNeverAsked(
    BuildContext context) async {
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
        //we are asking, so we have asked automatically atleast once
        SharedPrefsExt.setNotificationRequested(true);

        //unfocus in case this came up before the calibration set
        FocusScope.of(context).unfocus();

        //access not granted & we HAVE NOT already asked them directly
        return await reactToExplainingNotificationPermission(
          automaticallyOpened: true,
        );
      }
    }
  }
}

Future<bool> reactToExplainingNotificationPermission({
  required bool automaticallyOpened,
}) async {
  BuildContext? context = ExercisePage.globalKey.currentContext;
  if (context == null) {
    return false;
  } else {
    //explain why we are asking first (restricted doesn't matter yet)
    if (await explainNotificationPermission(context)) {
      //they would accept
      if (await reactToWouldAcceptNotificationPermission(
        context,
        automaticallyOpened: automaticallyOpened,
      )) {
        return true;
      } else {
        //they said they would grant us permission and they didn't
        return await reactToNotificationPermissionRejected(
          context,
          automaticallyOpened: automaticallyOpened,
        );
      }
    } else {
      //after explaining why they still didn't want to
      return await reactToNotificationPermissionRejected(
        context,
        automaticallyOpened: automaticallyOpened,
      );
    }
  }
}

//TODO: platform specific permission request
Future<bool> reactToWouldAcceptNotificationPermission(
  BuildContext context, {
  required bool automaticallyOpened,
}) async {
  //is restricted, show them the appropiate pop up
  if (await Permission.notification.status.isRestricted) {
    return true;
  } else {
    //TODO: handle is denied or is permanently denied

    //ask on each platform
    if (Platform.isAndroid) {
      // Android-specific code
      //TODO: android specific request
      //PermissionStatus status = await Permission.notification.request();
    } else if (Platform.isIOS) {
      // request iOS-specific permission
      bool? permissionGranted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    return false;
  }
}

//show them where they can enable the permission later if it makes sense
Future<bool> reactToNotificationPermissionRejected(
  BuildContext context, {
  required bool automaticallyOpened,
}) async {
  //they know where to open it from
  if (automaticallyOpened == false) {
    //so assume their rejection is final
    return false;
  } else {
    //they might not know where to open it from
    if (await showEnableNotificationsButtonLocation(context)) {
      //they changed their minds
      return await reactToWouldAcceptNotificationPermission(
        context,
        //false since they alreayd saw where the button location is this from time around
        automaticallyOpened: false,
      );
    } else {
      //they didn't change their minds
      return false;
    }
  }
}

//explain initial -> explainNotificationPermission
//explain restriction -> showRestrictedPopUp
//explain manual -> requestThatYouGoToAppSettings
//where to find if deny from automatic -> showEnableNotificationsButtonLocation
