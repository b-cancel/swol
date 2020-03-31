//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:permission_handler/permission_handler.dart';

//internal: action
import 'package:swol/action/buttonLocationPopUp.dart';
import 'package:swol/action/ifAllow.dart';
import 'package:swol/action/page.dart';

//internal: shared
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'package:swol/shared/widgets/simple/playOnceGif.dart';
import 'package:swol/shared/methods/theme.dart';

//PERMISSION REQUESTOR
//NOTE: here status is NOT granted
//but could be anything else
//INCLUDING RESTRICTED

//we include restricted since it only matters if the restriction exists
//IF the user decides to enable the permssion
requestNotificationPermission(
  PermissionStatus status,
  //on complete HAS TO RUN
  //regardless of what pop up path the user takes 
  Function onComplete,
  {bool automaticallyOpened: true}) async{
  //by now regardless of the user approving or not the permission has been requested
  //NOTE: even in the case where the permission is restricted
  //they may not be able to lift the restriction
  //so showing it all the time is going to be really annoying
  SharedPrefsExt.setNotificationRequested(true);

  //functions
  Function onDeny = () {
    //make sure the user knows where the button is
    //will always call on complete
    maybeShowButtonLocation(
      status, 
      onComplete, 
      automaticallyOpened,
    );
  };

  //inform the user of the permission they SHOULD have for and ideal experience
  //let let them decide what they will do
  showDialog(
    context: ExercisePage.globalKey.currentContext,
    //the user MUST respond
    barrierDismissible: false,
    //show pop up
    builder: (BuildContext context) {
      //convert the pop ups that appear after this one closes into light ones
      //primarily for scenarios where you have the icon pop ups
      return Theme(
        data: MyTheme.light,
        child: WillPopScope(
          onWillPop: () async{
            //if automatically open
            //  pressing back button MAY BE accidental
            //  but the button pop up will give them a chance
            //  to undo their accidental action
            //  *BUT* they won't know the reason the setting is being requested
            //so we simply disable the back button and force them to take an action
            if(automaticallyOpened){
              //dont allow pop up to go away
              return false;
            }
            else{ //we assume an accidental button press
              //assume the clear option
              onDeny();

              //allow poping
              //they opened his pop up, they know what they are doing
              return true;
            }
          },
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
                        "To Be Notified",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                      Text(
                        "When Your Break Is Finished",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Allow Notifications",
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
                onPressed: (){
                  //remove this pop up
                  //only one pop up at a time
                  Navigator.of(context).pop();

                  //tell user of button location if needed
                  onDeny();
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 8.0,
                ),
                child: RaisedButton(
                  child: Text("Allow"),
                  color: MyTheme.dark.accentColor,
                  onPressed: () async{
                    //pop ourselves
                    Navigator.of(context).pop();

                    //the user wants to allow 
                    //but now handle all the different ways 
                    //we MIGHT have to go about that
                    onAllow(
                      status, 
                      onComplete, 
                      automaticallyOpened,
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
}