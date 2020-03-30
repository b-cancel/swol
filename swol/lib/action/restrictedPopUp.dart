//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:permission_handler/permission_handler.dart';
import 'package:swol/action/buttonLocationPopUp.dart';
import 'package:swol/action/ifAllow.dart';

//internal
import 'package:swol/shared/methods/theme.dart';

//we only care to tell the user where the button is when they deny
//if they don't already know
//so we check if we are on the page with the button to determine if we should show the pop up
showRestrictedPopUp(
  BuildContext whiteContext, 
  PermissionStatus status,
  //on complete HAS TO RUN
  //regardless of what pop up path the user takes 
  Function onComplete,
  bool automaticallyOpened,
  ) async{
  showDialog(
    context: whiteContext,
    //the user MUST respond
    barrierDismissible: false,
    //show pop up
    builder: (BuildContext context) {
      return Theme(
        data: MyTheme.light,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          contentPadding: EdgeInsets.all(0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.0),
                  topLeft: Radius.circular(12.0),
                ),
                child: Container(
                  color: Colors.red,
                  width: MediaQuery.of(context).size.width,
                  height: 128,
                  padding: EdgeInsets.all(24),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Container(
                      child: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 24,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "You Are Restricted",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            Text(
                              "from granting us access",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
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
                              text: "Parental Controls",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " or a ",
                            ),
                            TextSpan(
                              text: "Security Option",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " isn't going to allow you to grant us access.\n\n"
                            ),
                            TextSpan(
                              text: "Remove The Restriction",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " and Try Again.\n\n"
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text("I'll do it later"),
              onPressed: () {
                //pop ourselves
                Navigator.of(context).pop();

                //make sure the user knows where the button is
                //will always call on complete
                maybeShowButtonLocation(
                  context, 
                  status, 
                  onComplete, 
                  automaticallyOpened,
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 8.0,
              ),
              child: RaisedButton(
                child: Text("Try Again"),
                color: Theme.of(context).accentColor,
                onPressed: () async{
                  //maybe the user made the required change
                  //check again
                  PermissionStatus status = await PermissionHandler().checkPermissionStatus(
                    PermissionGroup.notification,
                  );

                  //the user wants to allow 
                  //but now handle all the different ways 
                  //we MIGHT have to go about that
                  //becuase of the MIGHT
                  //we handle poping in can allow
                  onAllowShouldHandlePoping(
                    context, 
                    status, 
                    onComplete, 
                    automaticallyOpened,
                  );
                },
              ),
            )
          ],
        ),
      );
    },
  );
}