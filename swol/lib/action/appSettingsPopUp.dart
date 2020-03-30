//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:permission_handler/permission_handler.dart';

//internal: action
import 'package:swol/action/buttonLocationPopUp.dart';
import 'package:swol/action/page.dart';

//internal: shared
import 'package:swol/shared/widgets/simple/ourHeaderIconPopUp.dart';
import 'package:swol/shared/widgets/simple/listItem.dart';
import 'package:swol/shared/methods/theme.dart';

//you rejected the ez way, now you can only do it the hard way...
requestThatYouGoToAppSettings(
  PermissionStatus status,
  Function onComplete,
  bool automaticallyOpened,
) async {
  showCustomHeaderIconPopUp(
    ExercisePage.globalKey.currentContext,
    [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Manually",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              "Enable Notifications",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              "In App Settings",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
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
                      text: "Since ",
                    ),
                    TextSpan(
                      text: "you manually disabled notifications",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ", you will need to manually re-enable them.\n\n",
                    ),
                    TextSpan(
                      text: "You can do so, by\n",
                    ),
                  ],
                ),
              ),
            ),
            ListItem(
              circleText: "1",
              circleTextColor: Colors.white,
              circleColor: Colors.blue,
              content: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "Navigating to the ",
                    ),
                    TextSpan(
                      text: "App Info",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: " page, with the button on the bottom right",
                    ),
                  ],
                ),
              ),
            ),
            ListItem(
              circleText: "2",
              circleTextColor: Colors.white,
              circleColor: Colors.blue,
              content: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "Scrolling to the ",
                    ),
                    TextSpan(
                      text: "App Settings Section",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListItem(
              circleText: "3",
              circleTextColor: Colors.white,
              circleColor: Colors.blue,
              content: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "Tapping ",
                    ),
                    TextSpan(
                      text: "Notifications",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListItem(
              circleText: "4",
              circleTextColor: Colors.white,
              circleColor: Colors.blue,
              content: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "Turning On ",
                    ),
                    TextSpan(
                      text: "Show notifications",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListItem(
              circleText: "5",
              circleTextColor: Colors.white,
              circleColor: Colors.blue,
              content: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "Making sure all the switches in the ",
                    ),
                    TextSpan(
                      text: "Categories Section",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: " are set to On",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
    Icon(
      Icons.settings,
      color: Colors.white,
    ),
    headerBackground: MyTheme.dark.cardColor,
    dismissOnTouchOutside: false,
    clearBtn: FlatButton(
      child: new Text("Nevermind"),
      onPressed: () {
        //pop ourselves
        Navigator.of(
          ExercisePage.globalKey.currentContext,
        ).pop();

        //make sure the user knows where they can re-enable
        //if they didnt already get here from pressing the button
        maybeShowButtonLocation(
          status,
          onComplete,
          automaticallyOpened,
        );
      },
    ),
    colorBtn: RaisedButton(
      onPressed: () {
        PermissionHandler().openAppSettings();
        //NOTE: that complete MAY run below
      },
      child: CompleteOnResumeIfPermissionGranted(
        onComplete: onComplete,
        child: Text("App Info"),
      ),
    ),
  );
}

class CompleteOnResumeIfPermissionGranted extends StatefulWidget {
  CompleteOnResumeIfPermissionGranted({
    @required this.onComplete,
    @required this.child,
  });

  final Function onComplete;
  final Widget child;

  @override
  _CompleteOnResumeIfPermissionGrantedState createState() =>
      _CompleteOnResumeIfPermissionGrantedState();
}

class _CompleteOnResumeIfPermissionGrantedState
    extends State<CompleteOnResumeIfPermissionGranted>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  popIfPermissionGranted() async {
    PermissionStatus status = await PermissionHandler().checkPermissionStatus(
      PermissionGroup.notification,
    );

    if (status == PermissionStatus.granted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      popIfPermissionGranted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
