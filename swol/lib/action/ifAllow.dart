import 'package:permission_handler/permission_handler.dart';

onAllow(PermissionStatus status, Function onComplete){
  /*
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
                  }*/
}