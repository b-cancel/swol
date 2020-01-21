import 'package:flutter/material.dart';

//internal: excercise
import 'package:swol/excercise/defaultDateTimes.dart';
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/shared/widgets/simple/onboarding.dart';

//internal: utils
import 'package:swol/utils/onboarding.dart';

class SaveButton extends StatefulWidget {
  const SaveButton({
    Key key,
    @required this.delay,
    @required this.showSaveButton,
    
    @required this.namePresent,
    @required this.nameFocusNode,
    @required this.shownSaveVN,
    @required this.name,
    @required this.url,
    @required this.note,
    @required this.functionIndex,
    @required this.repTarget,
    @required this.recoveryPeriod,
    @required this.setTarget,
    @required this.navSpread,
    @required this.nameError,
    @required this.showSaveDuration,
  }) : super(key: key);

  final Duration delay;
  final ValueNotifier<bool> showSaveButton;

  final ValueNotifier<bool> namePresent;
  final FocusNode nameFocusNode;
  final ValueNotifier<bool> shownSaveVN;
  final ValueNotifier<String> name;
  final ValueNotifier<String> url;
  final ValueNotifier<String> note;
  final ValueNotifier<int> functionIndex;
  final ValueNotifier<int> repTarget;
  final ValueNotifier<Duration> recoveryPeriod;
  final ValueNotifier<int> setTarget;
  final ValueNotifier<bool> navSpread;
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
    if(widget.shownSaveVN.value == false){
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
        curve: Curves.easeInOut,
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

                //add workout to our list
                await ExcerciseData.addExcercise(
                  AnExcercise(
                    //basic
                    name: widget.name.value,
                    url: widget.url.value,
                    note: widget.note.value,

                    //other
                    predictionID: widget.functionIndex.value,
                    repTarget: widget.repTarget.value,
                    recoveryPeriod: widget.recoveryPeriod.value,
                    setTarget: widget.setTarget.value,

                    //---
                    lastTimeStamp: LastTimeStamp.newDateTime(),
                  ),
                );

                //exit pop up
                widget.navSpread.value = false;
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
        //change variable globally
        OnBoarding.saveShown();

        //change variable locally
        widget.shownSaveVN.value = true;

        //request focus
        FocusScope.of(context).requestFocus(widget.nameFocusNode);
      },
    );
  }
}