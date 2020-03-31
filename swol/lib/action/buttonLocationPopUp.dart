//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:permission_handler/permission_handler.dart';

//internal
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/action/ifAllow.dart';
import 'package:swol/action/page.dart';

//we only care to tell the user where the button is when they deny
//if they don't already know
//so we check if we are on the page with the button to determine if we should show the pop up
maybeShowButtonLocation(
    PermissionStatus status,
    //on complete HAS TO RUN
    //regardless of what pop up path the user takes
    Function onComplete,
    bool automaticallyOpened) async {
  if (automaticallyOpened) {
    showDialog(
      context: ExercisePage.globalKey.currentContext,
      //force to user to chose
      barrierDismissible: false,
      //show pop up
      builder: (BuildContext context) {
        return Theme(
          data: MyTheme.light,
          child: WillPopScope(
            onWillPop: () async{
              //if automaticalyOpened the notification pop up
              //or a sequence of other pop ups had to open before
              //so the chances of this being closed on accident are low
              //so we can assume that the user wants to play the negative option
              //we ONLY open this pop up IF automaticallyOpen so...

              //run the negative option
              onComplete();

              //allow pop
              return true;
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              contentPadding: EdgeInsets.all(0),
              content: Container(
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
                                            fontSize: 32,
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
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: new Text("Understood"),
                  onPressed: () {
                    //notification
                    //only one pop up at a time
                    Navigator.of(context).pop();

                    //run on complete
                    onComplete();
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 8.0,
                  ),
                  child: RaisedButton(
                    child: Text("Enable Notificaions"),
                    color: Theme.of(context).accentColor,
                    onPressed: () async {
                      //pop ourselves
                      Navigator.of(context).pop();

                      //the user wants to allow
                      //but now handle all the different ways
                      //we MIGHT have to go about that
                      onAllow(
                        status, 
                        onComplete,
                        //this pop up already showed them where the button is
                        //no need to show them again
                        false,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  } else {
    onComplete();
  }
}
