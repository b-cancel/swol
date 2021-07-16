//returns true if granted, false if not
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swol/action/page.dart';
import 'package:swol/permissions/ask.dart';
import 'package:swol/permissions/specific/restrictedPopUp.dart';
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'dart:io' show Platform;

import '../../main.dart';
import 'buttonLocationPopUp.dart';
import 'explainWhyPermission.dart';
import 'manualEnablePopUp.dart';

//requires a seperate shared preferences variable because this permission is granted by default by some systems
//specifically android
//and ios does the same provisionally if you simply schedule a notification without asking first
Future<bool> askForPermissionIfNotGrantedAndWeNeverAsked(
  BuildContext context,
) async {
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
  PermissionStatus status = await Permission.notification.status;
  if (status.isGranted || status.isLimited) {
    return true;
  } else {
    BuildContext? context = ExercisePage.globalKey.currentContext;

    //react accordingly
    if (context == null) {
      return false;
    } else {
      //unfocus in case this came up before the calibration set
      FocusScope.of(context).unfocus();

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
}

//if restricted is a special case
Future<bool> reactToWouldAcceptNotificationPermission(
  BuildContext context, {
  required bool automaticallyOpened,
}) async {
  print("react to would accept");

  PermissionStatus status = await Permission.notification.status;
  if (status.isGranted || status.isLimited) {
    return true;
  } else {
    print("ask");
    //permission might be... denied or permanently denied... we'll find out which promptly
    if (Platform.isAndroid || Platform.isIOS) {
      // Android-specific code
      NextAction nextAction = await tryToGetPermission(Permission.notification);
      print("next action: " + nextAction.toString());
      //react to result
      if (nextAction == NextAction.Continue) {
        return true;
      } else if (nextAction == NextAction.TryAgainLater) {
        return false;
      } else {
        if (nextAction == NextAction.ExplainRestriction) {
          print("restrict");

          //show them whats up
          await showRestrictedPopUp(context);

          //show them where to ask again in the future
          return reactToNotificationPermissionRejected(
            context,
            automaticallyOpened: automaticallyOpened,
          );
        } else if (nextAction == NextAction.EditManually) {
          print("manual");

          //show them whats up
          await requestThatYouGoToAppSettings(context);

          //show them where to ask again in the future
          return reactToNotificationPermissionRejected(
            context,
            automaticallyOpened: automaticallyOpened,
          );
        } else {
          //nextAction == NextAction.Error
          return false;
        }
      }
    } else {
      return false;
    }
  }
}

/*
else if (Platform.isIOS) {
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
*/

//show them where they can enable the permission later if it makes sense
Future<bool> reactToNotificationPermissionRejected(
  BuildContext context, {
  required bool automaticallyOpened,
}) async {
  PermissionStatus status = await Permission.notification.status;
  if (status.isGranted || status.isLimited) {
    return true;
  } else {
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
}

//requestThatYouGoToAppSettings(context); //dynamic
//showRestrictedPopUp(context); //dynamic
//showEnableNotificationsButtonLocation(context); //bool
//explainNotificationPermission(context); //bool
