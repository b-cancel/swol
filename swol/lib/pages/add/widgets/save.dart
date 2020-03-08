//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'package:swol/shared/widgets/complex/onBoarding/wrapper.dart';
import 'package:swol/shared/functions/defaultDateTimes.dart';
import 'package:swol/shared/methods/excerciseData.dart';
import 'package:swol/shared/functions/onboarding.dart';
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/main.dart';

//widget
class SaveButton extends StatefulWidget {
  const SaveButton({
    Key key,
    @required this.delay,
    @required this.showSaveButton,
    
    @required this.namePresent,
    @required this.nameFocusNode,
    @required this.name,
    @required this.url,
    @required this.note,
    @required this.functionIndex,
    @required this.repTarget,
    @required this.recoveryPeriod,
    @required this.setTarget,
    @required this.nameError,
    @required this.showSaveDuration,
  }) : super(key: key);

  final Duration delay;
  final ValueNotifier<bool> showSaveButton;

  final ValueNotifier<bool> namePresent;
  final FocusNode nameFocusNode;
  final ValueNotifier<String> name;
  final ValueNotifier<String> url;
  final ValueNotifier<String> note;
  final ValueNotifier<int> functionIndex;
  final ValueNotifier<int> repTarget;
  final ValueNotifier<Duration> recoveryPeriod;
  final ValueNotifier<int> setTarget;
  final ValueNotifier<bool> nameError;
  final Duration showSaveDuration;

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {

  //so it can be added and removed from listeners
  updateState(){
    if(mounted) setState(() {});
  }
  
  @override
  void initState() {
    //add listeners
    widget.showSaveButton.addListener(updateState);
    widget.namePresent.addListener(updateState);

    //start onbaording if needed
    if(SharedPrefsExt.getSaveShown().value == false){
      //NOTE: this will eventually request the focus of name
      OnBoarding.discoverSaveExcercise(context);

      //the user already knows where the save button is
      widget.showSaveButton.value = true;
    }
    else{
      //autofocus on the name as soon as possible
      WidgetsBinding.instance.addPostFrameCallback((_){
        FocusScope.of(context).requestFocus(widget.nameFocusNode);
      });

      //remind the user of the save button location
      Future.delayed(
        widget.delay, (){
        widget.showSaveButton.value = true;
      });
    }

    //super init
    super.initState();
  }

  @override
  void dispose() {
    widget.showSaveButton.removeListener(updateState);
    widget.namePresent.removeListener(updateState);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FeatureWrapper(
      featureID: AFeature.SaveExcercise.toString(),
      tapTarget: Container(
        width: 72,
        child: RaisedButton(
          onPressed: null,
          child: Text(
            "Save",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      text: "Only after naming the excercise\n"
      + "will the button become active\n"
      + "and allow you to save",
      child: AnimatedContainer(
        duration: widget.showSaveDuration,
        curve: Curves.bounceInOut,
        constraints: BoxConstraints(
          //no limit vs limit
          //the 100 is so large its never going to be a limitation
          maxHeight: (widget.showSaveButton.value) ? 100 : 0,
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: RaisedButton(
            color: (widget.namePresent.value) 
            ? Theme.of(context).accentColor 
            : Colors.grey,
            onPressed: ()async{
              if(widget.namePresent.value){
                //remove keyboard
                FocusScope.of(context).unfocus();

                DateTime theNewDateTime = LastTimeStamp.newDateTime();
                print("the new date time is: " + theNewDateTime.toString());

                //add workout to our list
                await ExcerciseData.addExcercise(
                  AnExercise(
                    //basic
                    widget.name.value,
                    widget.url.value,
                    widget.note.value,

                    //other
                    widget.functionIndex.value,
                    widget.repTarget.value,
                    widget.recoveryPeriod.value,
                    widget.setTarget.value,

                    //---
                    theNewDateTime,
                  ),
                );

                //exit pop up
                App.navSpread.value = false;
                Navigator.pop(context);
              }
              else{
                //show the error if needed
                widget.nameError.value = true;

                //focus on the field so the user notices the error
                FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(widget.nameFocusNode);
              }
            },
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      //top, right
      top: true,
      left: false,
      //only 1 thing
      doneInsteadOfNext: true,
      nextFeature: (){
        SharedPrefsExt.setSaveShown(true);
        //request focus AFTER the feature has been shown
        //so they keyboard doesn't pop up with the onboarding window
        FocusScope.of(context).requestFocus(widget.nameFocusNode);
      },
    );
  }
}