//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:permission_handler/permission_handler.dart';

//internal
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/widgets/simple/playOnceGif.dart';

//requestor
requestNotificationPermission(BuildContext context, Function onComplete) async{
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // return object of type Dialog
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
                  color: Theme.of(context).accentColor,
                  child: Center(
                    child: Container(
                      width: 128,
                      height: 128,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: PlayGifOnce(
                          assetName: "assets/notification/blueShadow.gif",
                          frameCount: 125, 
                          runTimeMS: 2500,
                          colorWhite: false,
                        ),
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
                    Text(
                      "Grant Us Access",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                    Text(
                      "To Send Notifications",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
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
                              text: "It's important that you recover",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " before moving onto your next set.\n\n",
                            ),
                            TextSpan(
                              text: "But "
                            ),
                            TextSpan(
                              text: "it's not fun to have to wait ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "for the clock to tick down.\n\n"
                            ),
                            TextSpan(
                              text: "If you grant us access to send notifications, ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "we can alert you",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " when you are ready for you next set.",
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
              child: new Text("Deny"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 8.0,
              ),
              child: RaisedButton(
                child: Text("Allow"),
                color: Theme.of(context).accentColor,
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      );
    },
  );
}
