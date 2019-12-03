//TODO: add them... they are going to be alot of work... I should finish the app first...
//https://pub.dev/packages/flutter_local_notifications#-readme-tab-

//TODO: add the notifications to come up regardless if the app is closed or not
//TODO:   or if we are in the app or not

//TODO: notifications overview to we guarantee that they show up as a heads up notification
//https://developer.android.com/guide/topics/ui/notifiers/notifications.html#Heads-up
//TODO: as a final step bundle notifications https://developer.android.com/training/notify-user/group.html

/*
INITIALIZE
//setup the notification plugin
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    //TODO: see if I can use '@mipmap/ic_launcher' instead of 'app_icon'
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
*/

  /*
  Notes around initialisation: if the app had been launched by tapping on a notification created by this plugin, 
  calling initialize is what will trigger the onSelectNotification to trigger to handle the notification 
  that the user tapped on. 
  An alternative to handling the "launch notification" is to 
  call the getNotificationAppLaunchDetails method that is available in the plugin. 
  This could be used, for example, to change the home route of the app for deep-linking. 
  Calling initialize will still cause the onSelectNotification callback to fire for the launch notification. 
  It will be up to developers to ensure that they don't process the same notification twice 
  (e.g. by storing and comparing the notification id).
  */

  /*
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );
}
  */

  /*
  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }
  */


  //channel details that is required for Android 8.0+

  //The payload has been specified ('item x'), 
  //that will passed back through your application when the user has tapped on a notification.

  //Note that for Android devices that notifications will only in appear in the tray 
  //and won't appear as a toast aka heads-up notification 
  //unless things like the priority/importance has been set appropriately. 
  //Refer to the Android docs

  //Note that the "ticker" text is passed here though it is optional and specific to Android. 
  //This allows for text to be shown in the status bar on older versions of Android when the notification is shown.


  /*
  // Method 2
Future _showNotificationWithDefaultSound() async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      //playSound: false, 
      importance: Importance.Max, priority: Priority.High,
      //ticker: 'ticker' //on example
      );
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails(
    //(presentSound: false);
  );
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'New Post',
    'How to Show Notification in Flutter',
    platformChannelSpecifics,
    payload: 'Default_Sound', //'No_Sound',
  );
}
  */

  /*
  Note that on Android devices, 
  the default behaviour is that the notification may not be delivered at the specified time 
  when the device in a low-power idle mode. 
  This behaviour can be changed by setting the optional parameter named 
  androidAllowWhileIdle to true when calling the schedule method.
  */

  /*
  var scheduledNotificationDateTime =
        new DateTime.now().add(new Duration(seconds: 5));
var androidPlatformChannelSpecifics =
    new AndroidNotificationDetails('your other channel id',
        'your other channel name', 'your other channel description');
var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails();
NotificationDetails platformChannelSpecifics = new NotificationDetails(
    androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
await flutterLocalNotificationsPlugin.schedule(
    0,
    'scheduled title',
    'scheduled body',
    scheduledNotificationDateTime,
    platformChannelSpecifics);
  */

  /*
  Retrieve pending notification requests #
var pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  */

  /*
  Cancelling/deleting a notification #
// cancel the notification with id value of zero
await flutterLocalNotificationsPlugin.cancel(0);
Cancelling/deleting all notifications #
await flutterLocalNotificationsPlugin.cancelAll();
Get details on if the app was launched via a notification #
 var notificationAppLaunchDetails =
     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  */