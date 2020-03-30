//flutter
import 'package:flutter/material.dart';

//packages
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swol/action/notificationPopUp.dart';

//build
class NotificationSwitch extends StatefulWidget {
  @override
  _NotificationSwitchState createState() => _NotificationSwitchState();
}

//although unlikely
//its possible for the user to 
//1. initially have granted to permission
//2. then MANUALLY turn it off
//and EXPECT the button to turn it on to be there
//since its so unlikely and the solution would REQUIRE us to reload every second
//and that may cause more problems in the general cases we ignore that problem
class _NotificationSwitchState extends State<NotificationSwitch> with WidgetsBindingObserver{
  bool showButton;
  PermissionStatus status;

  updateState() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    //super init
    super.initState();

    //more often than not users will aprove it so the button wont show
    showButton = false;
    updateShowButton();

    //for on resume
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      completeIfPermissionGranted();
    }
  }

  completeIfPermissionGranted() async {
    PermissionStatus status = await PermissionHandler().checkPermissionStatus(
      PermissionGroup.notification,
    );

    if (status == PermissionStatus.granted) {
      updateShowButton();
    }
  }
  
  updateShowButton()async{
    status = await PermissionHandler().checkPermissionStatus(
      PermissionGroup.notification,
    );

    //if anything else but granted the button should show
    showButton = (status != PermissionStatus.granted);

    //update show hide state
    updateState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Visibility(
        visible: showButton,
        child: IconButton(
          tooltip: 'Enable Notifications',
          onPressed: () async {
            requestNotificationPermission(
              status, 
              updateShowButton,
              automaticallyOpened: false,
            );
          },
          icon: Container(
            child: Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SpinKitDoubleBounce(
                      color: Theme.of(context).accentColor,
                      size: 1,
                      duration: Duration(milliseconds: 1000),
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    Icons.notifications,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}