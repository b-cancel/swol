//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swol/action/page.dart';

//internal: shared
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'package:swol/shared/structs/anExercise.dart';

//internal: other
import 'package:swol/action/notificationPopUp.dart';
import 'package:swol/main.dart';

//called when
//CASE 1. we hit the back button with a valid set
//    the invalid pop up wont show but the permission pop ups MIGHT
//CASE 2. we arrive at the SET BREAK page
//    the same way the keyboard pops up after arriving at the SET RECORD page

//NOTE: so to next set should not schedule the notification
//since for CASE 1: we ask for permission... then do next set... then schedule
//and for CASE 2: we do next set... then we ask for permission... then schedule

//NOTE: onComplete MUST RUN regardless of anything
askForPermissionIfNotGrantedAndWeNeverAsked(
    BuildContext context, 
    Function onComplete,
  ) async {
  //regardless of whether its been requested before
  //we first check if it needs to be requested
  PermissionStatus status = await PermissionHandler().checkPermissionStatus(
    PermissionGroup.notification,
  );

  //we don't have the permission
  if (status != PermissionStatus.granted) {
    //but have we requested it before?
    bool notificationRequested =
        SharedPrefsExt.getNotificationRequested().value;

    //IF the notification has already been requested
    //it was either 1. denied
    //or 2. MANUALLY given and then removed
    //NOTE: if its automatically given and then removed it HAS NOT been requested

    //else we need to ask for it
    if (notificationRequested == false) {
      //not granted or restricted
      //might be denied or unknown
      await requestNotificationPermission(
        status, 
        onComplete,
        automaticallyOpened: true,
      );
    } else {
      onComplete();
    }
  } else {
    //we have the permission (if its automatic)
    //NOTE: IF they disable it after it was given automatically
    //then we will request is for the first time above
    onComplete();
  }
}

//we only schedule it IF we have the permission
//NOTE: asking for permission is a completely seperate process because of the cases described ON TOP
scheduleNotification(AnExercise exercise) async {
  int id = exercise.id;

  //generate the DT that we want the notification to come up on
  DateTime notificationDT = exercise.tempStartTime.value.add(
    exercise.recoveryPeriod,
  );

  //only schedule it if it hasn't yet passed
  bool inTheFuture = notificationDT.isAfter(DateTime.now());
  if (inTheFuture) {
    //check if we have permission to schedule a notification
    PermissionStatus status = await PermissionHandler().checkPermissionStatus(
      PermissionGroup.notification,
    );

    //if we do then do so
    if (status == PermissionStatus.granted) {
      //safe cancel before to avoid dups or errors
      await safeCancelNotification(id);

      //create the notification for this exercise
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'swol-ID', 'swol-Name', 'swol-Description',
        //user must act now
        importance: Importance.Max,
        priority: Priority.Max,
        //not BigText, BigPicture, Message, or Media
        //Maybe Inbox or Messaging
        style: AndroidNotificationStyle.Default,
        styleInformation: DefaultStyleInformation(
          false, //content not html
          false, //title not html
        ),
        //ultimate alert
        playSound: true,
        enableVibration: true,
        enableLights: true,
        //when the user taps it, it dismisses
        autoCancel: true,
        //the user can dismiss it
        ongoing: false,
        //the first alert should push them
        //by the second they have already lost the benefit
        onlyAlertOnce: true,
        //easier for the user to find
        channelShowBadge: true,
        //no progress showing
        showProgress: false,
        indeterminate: false,
        //updates won't happen
        channelAction: AndroidNotificationChannelAction.CreateIfNotExists,
        visibility: NotificationVisibility.Public,
        //for older versions of android
        ticker: 'Set Break Complete',
      );

      //permission request is handled elsewhere
      var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        presentAlert: false,
        presentBadge: false,
        presentSound: false,
      );

      //combine stuff for both platforms
      var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics,
        iOSPlatformChannelSpecifics,
      );

      //schedule the notification
      await flutterLocalNotificationsPlugin.schedule(
        //pass ID so we can remove it by id if needed
        id,
        //title
        'Set Break Complete for \"' + exercise.name + '\"',
        //content
        'Start your next set now for the best results',
        //when the notification will pop up
        notificationDT,
        //pass details created above
        platformChannelSpecifics,
        //pass ID so we can open to that page when user taps the excercise
        payload: id.toString(),
        //it should also trigger in low power mode
        androidAllowWhileIdle: true,
      );
    }
  }
}

scheduleNotificationAfterUpdate(AnExercise exercise) {
  if (ExercisePage.updateSet.value == false) {
    //update is complete because the value was set to false
    scheduleNotification(exercise);
  } else {
    //wait another frame for the update to finish
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scheduleNotificationAfterUpdate(exercise);
    });
  }
}

//TODO: check if we need permission to cancel a notifcation
//NOTE: used because perhaps canceling when there is nothing to cancel might break things on IOS
safeCancelNotification(int id) async {
  //check this ID has previously scheduled a notification
  List<PendingNotificationRequest> pendingNotificationRequests =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();

  //cancel it if we have it
  for (int i = 0; i < pendingNotificationRequests.length; i++) {
    PendingNotificationRequest thisRequest = pendingNotificationRequests[i];
    //we have it
    if (thisRequest.id == id) {
      //so we should cancel it
      await flutterLocalNotificationsPlugin.cancel(id);

      //since things go by ID no need to keep searching
      break;
    }
  }
}
