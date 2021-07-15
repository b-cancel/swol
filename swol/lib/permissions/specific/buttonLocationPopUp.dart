//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/widgets/simple/popUpAdjustments.dart';

//true for will Enable Notifications
//false for still don't want to enable notifications
Future<bool> showEnableNotificationsButtonLocation(BuildContext context) async {
  return await showDialog(
    context: context,
    //they must click the buttons
    barrierDismissible: false,
    //show pop up
    builder: (BuildContext context) {
      return Theme(
        data: MyTheme.light,
        child: WillPopScope(
          onWillPop: () async {
            //they must click the buttons
            return false;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            contentPadding: EdgeInsets.all(0),
            content: ScrollViewWithShadow(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Container(
                                color: MyTheme.dark.cardColor,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: MyTheme.light.cardColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12.0),
                                    bottomRight: Radius.circular(12.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 16.0,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "You're Missing Out!",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26,
                                          ),
                                        ),
                                        Text(
                                          "but when you're ready",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                                child: Image(
                                  image: AssetImage(
                                    "assets/notification/cropedLocation.gif",
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: MyTheme.light.cardColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.0),
                                    topRight: Radius.circular(12.0),
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(
                                    top: 24,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: RichText(
                                      textScaleFactor: MediaQuery.of(
                                        context,
                                      ).textScaleFactor,
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "You can ",
                                          ),
                                          TextSpan(
                                            text: "Enable Notifications",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " by tapping the ",
                                          ),
                                          TextSpan(
                                            text: "Bell Icon",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " on the ",
                                          ),
                                          TextSpan(
                                            text: "Top Right",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " of the ",
                                          ),
                                          TextSpan(
                                            text: "Break Timer",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      BottomButtonsThatResizeTRBL(
                        secondary: TextButton(
                          child: Text("Enable Notificaions"),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                        primary: ElevatedButton(
                          child: Text("Ok"),
                          style: ElevatedButton.styleFrom(
                            primary: MyTheme.dark.accentColor,
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop(false);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
