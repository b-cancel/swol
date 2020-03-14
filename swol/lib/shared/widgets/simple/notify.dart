import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:swol/main.dart';

scheduleNotification(int id, String name, DateTime notificationDT, {bool alsoCancel: true}) async{
    //cancel this if it was previously triggered
    if(alsoCancel){
      await flutterLocalNotificationsPlugin.cancel(id);
    }

    //create the notification for this exercise
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Channel-ID', 'Channel-Name', 'Channel-Description',
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

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, 
      iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.schedule(
      //pass ID so we can remove it by id if needed
      id,
      //title
      'Set Break Complete for \"' +  name + '\"', 
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