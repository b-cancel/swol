//dart
import 'dart:io' show Platform;

//flutter
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swol/action/notificationPopUp.dart';

//internal: action
import 'package:swol/action/tabs/record/field/customField.dart';
import 'package:swol/action/tabs/record/field/fieldIcon.dart';
import 'package:swol/action/popUps/textValid.dart';
import 'package:swol/action/page.dart';
import 'package:swol/main.dart';

//internal: shared
import 'package:swol/shared/functions/goldenRatio.dart';
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'package:swol/shared/methods/theme.dart';

//widget
class RecordFields extends StatefulWidget { 
  RecordFields({
    @required this.heroAnimDuration,
    @required this.weightFocusNode,
    @required this.repsFocusNode,
  });

  final Duration heroAnimDuration;
  final FocusNode weightFocusNode;
  final FocusNode repsFocusNode;

  //weight field
  @override
  _RecordFieldsState createState() => _RecordFieldsState();
}

class _RecordFieldsState extends State<RecordFields> {
  final TextEditingController weightController = new TextEditingController();

  final TextEditingController repsController = new TextEditingController();

  updateWeightNotifier() {
    ExercisePage.setWeight.value = weightController.text;
  }

  updateRepsNotifier() {
    ExercisePage.setReps.value = repsController.text;
  }

  @override
  void initState() {
    //supe init
    super.initState();

    //NOTE: set the initial values of our controllers from notifiers
    weightController.text = ExercisePage.setWeight.value;
    repsController.text = ExercisePage.setReps.value;

    //add listeners
    weightController.addListener(updateWeightNotifier);
    repsController.addListener(updateRepsNotifier);

    //autofocus if possible
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      if (Platform.isAndroid) { //we automatically have permission
        //TODO: cover the case where we don't
        //NOTE: if you don't wait until transition things begin to break
        Future.delayed(widget.heroAnimDuration * 1.5, () {
          if(mounted) focusOnFirstInvalid();
        });
      } else if (Platform.isIOS) {
        //regardless of whether its been requested before we first check if it needs to be requested
        PermissionStatus status = await PermissionHandler().checkPermissionStatus(
          PermissionGroup.notification,
        );

        //as for permission if needed
        if(status != PermissionStatus.granted){
          bool notificationRequested = SharedPrefsExt.getNotificationRequested().value;

          //the notification hasn't been previously requested automatically
          if(notificationRequested == false){
            //you can't enable this permission because the setting is restricted
            if(status == PermissionStatus.restricted){
              //You are not allowed to enable notifications

              //parental controls, some settings, another app,
              //or something else may be stopping you
              
              //Release the restriction to enable notifications

              //TODO: create the pop up that tells you the above
              //TODO: it should also tell you where to enable the notification when you remove the restriction
            }
            else{
              //not granted or restricted
              //might be denied or unknown
              await requestNotificationPermission(
                context, 
                status, (){
                if(mounted) focusOnFirstInvalid();
              });
            }

            //by now regardless of the user approving or not the permission has been requested
            SharedPrefsExt.setNotificationRequested(true);
          }
        }
        //ELSE: we have permission
      }

      /*
      //regardless if we have to request the permission or not
      //we need to now focus on first invalid
      Function onComplete = (){
        if(mounted) focusOnFirstInvalid();
      };

      //regardless of whether its been requested before we first check if it needs to be requested
      PermissionStatus status = await PermissionHandler().checkPermissionStatus(
        PermissionGroup.notification,
      );
      
      //trigger the pop up when needed
      //NOTE: we also check restricted because if its restricted the user presumably cant do anything about it
      //TODO: improve how we handle this restricted state
      if(status != PermissionStatus.granted && status != PermissionStatus.restricted){
        //this can occur if
        //1. the permission has never been granted before
        //2. the permission was once granted (automatically or manually)
        //  and the user decided to ungrant it (manually)

        //so to narrow down if the pop up should show
        //we check if we have asked before
        //NOTICE: if the permission was granted automatically
        //and the user then disabled it
        //we didn't ask, so the it should indeed pop up this time
        bool notificationPermissionRequested = SharedPrefsExt.getNotificationRequested().value;

        if(notificationPermissionRequested == false){
          //we can be here in 2 scenarios

          //1. the permission was automatically granted
          //  and then the user decided to manually ungrant it
          //2. the permission was not automatically granted 
          //  and its the first time the user is notified that they should grant it

          //in both scenarios we want to show the user the pop up

          requestNotificationPermission(
            context, 
            status, (){
            if(mounted) focusOnFirstInvalid();
          });
        }
        else{
          //NOTE: if you don't wait until transition things begin to break
          Future.delayed(widget.heroAnimDuration * 1.5, () {
            onComplete();
          });
        }
      }
      else{
        //NOTE: if you don't wait until transition things begin to break
        Future.delayed(widget.heroAnimDuration * 1.5, () {
          onComplete();
        });
      }
      */
    });

    //attach a listener so a change in it will cause a refocus
    //done from warning, error, and notes page
    ExercisePage.causeRefocusIfInvalid.addListener(focusOnFirstInvalid);
  }

  @override
  void dispose() {
    //remove listeners
    ExercisePage.causeRefocusIfInvalid.removeListener(focusOnFirstInvalid);

    //remove notifiers
    weightController.removeListener(updateWeightNotifier);
    repsController.removeListener(updateRepsNotifier);

    //super dispose
    super.dispose();
  }

  //if both are valid nothing happens
  //NOTE: in all cases where this is used the keyboard is guaranteed to be closed
  //and its closed automatically by unfocusing so there are no weird exceptions to cover
  focusOnFirstInvalid() {
    //maybe focus on weight
    if (isTextValid(weightController.text) == false) {
      //clear with value that could be nothing but invalid
      if(weightController.text == "0") weightController.clear();
      //request focus
      FocusScope.of(context).requestFocus(widget.weightFocusNode);
      //NOTE: cursor automatically gets shifted to the end
    } else { //maybe focus on reps
      if (isTextValid(repsController.text) == false) {
        //clear with value that could be nothing but invalid
        if(repsController.text == "0") repsController.clear();
        //request focus
        FocusScope.of(context).requestFocus(widget.repsFocusNode);
        //NOTE: cursor automatically gets shifted to the end
      }
    }

    //whatever cause the refocusing
    //no longer needs it
    ExercisePage.causeRefocusIfInvalid.value = false;
  }

  @override
  Widget build(BuildContext context) {
    //-32 is for 16 pixels of padding from both sides
    double screenWidth = MediaQuery.of(context).size.width - 32;
    List<double> goldenBS = measurementToGoldenRatioBS(screenWidth);
    double iconSize = goldenBS[1];
    List<double> golden2BS = measurementToGoldenRatioBS(iconSize);
    iconSize = golden2BS[1];
    double borderSize = 3;

    //build
    return Theme(
      //NOTE: must be edited here since the color differ 
      //from what they are for the name, notes, and link field
      data: MyTheme.dark.copyWith(
        textSelectionColor: MyTheme.dark.primaryColorDark,
        //NOTE: probably due to a flutter bug I can't set the selection 
        //"textSelectionHandleColor" here because it just won't show
      ),
      child: Container(
        height: (iconSize * 2) + 8,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RecordField(
              focusNode: widget.weightFocusNode,
              controller: weightController,
              isLeft: true,
              borderSize: borderSize,
              otherFocusNode: widget.repsFocusNode,
              otherController: repsController
            ),
            Column(
              children: <Widget>[
                TappableIcon(
                  focusNode: widget.weightFocusNode,
                  iconSize: iconSize,
                  borderSize: borderSize,
                  icon: Padding(
                    padding: const EdgeInsets.only(
                      right: 8,
                    ),
                    child: Icon(
                      FontAwesomeIcons.dumbbell,
                    ),
                  ),
                  isLeft: true,
                ),
                TappableIcon(
                  focusNode: widget.repsFocusNode,
                  iconSize: iconSize,
                  borderSize: borderSize,
                  icon: Icon(Icons.repeat),
                  isLeft: false,
                ),
              ],
            ),
            RecordField(
              focusNode: widget.repsFocusNode,
              controller: repsController,
              isLeft: false,
              borderSize: borderSize,
              otherFocusNode: widget.weightFocusNode,
              otherController: weightController,
            ),
          ],
        ),
      ),
    );
  }
}