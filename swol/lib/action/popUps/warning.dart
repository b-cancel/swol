import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:swol/action/page.dart';
import 'package:swol/main.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//weight
  final TextEditingController weightController = new TextEditingController();
  final FocusNode weightFocusNode = new FocusNode();

  //reps
  final TextEditingController repsController = new TextEditingController();
  final FocusNode repsFocusNode = new FocusNode();

//if both are valid nothing happens
  //NOTE: in all cases where this is used the keyboard is guaranteed to be closed
  //and its closed automatically by unfocusing so there are no weird exceptions to cover
  focusOnFirstInValid(BuildContext context){
    if(ExcercisePage.pageNumber.value == 1){
      //grab weight stuff
      bool weightEmpty = weightController.text == "";
      bool weightZero = weightController.text == "0";
      bool weightInvalid = weightEmpty || weightZero;

      //maybe focus on weight
      if(weightInvalid){
        weightController.clear(); //since invalid maybe 0
        FocusScope.of(context).requestFocus(weightFocusNode);
      }
      else{
        //grab reps stuff
        bool repsEmtpy = repsController.text == "";
        bool repsZero = repsController.text == "0";
        bool repsInvalid = repsEmtpy || repsZero;

        //maybe focus on reps
        if(repsInvalid){
          repsController.clear(); //since invalid maybe 0
          FocusScope.of(context).requestFocus(repsFocusNode);
        }
      }
    }
  }

//determine whether we should warn the user
noWarning(
  BuildContext context, 
  AnExcercise excercise,
{bool alsoPop: false}) {
    DateTime startTime = excercise.tempStartTime.value;
    bool timerNotStarted = (startTime == AnExcercise.nullDateTime);

    //if the timer hasn't yet started we may need to bring up the pop up
    if (timerNotStarted) {
      //check for data validity
      bool weightValid = weightController.text != "";
      weightValid &= weightController.text != "0";
      bool repsValid = repsController.text != "";
      repsValid &= repsController.text != "0";

      //since this isthe warning we only care of atleast one if filled
      //else we assume a misclick
      if (weightValid || repsValid) {
        //NOTE: this assumes the user CANT type anything except digits of the right size
        bool setValid = weightValid && repsValid;

        //remove focus so the pop up doesnt bring it back
        FocusScope.of(context).unfocus();

        //bring up pop up
        AwesomeDialog(
          context: context,
          isDense: false,
          dismissOnTouchOutside: true,
          dialogType: DialogType.WARNING,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          body: Column(
            children: [
              Text(
                "Begin Your Set Break",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              Text(
                "to avoid losing your set",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      weightAndRepsToDescription(
                        weightController.text,
                        repsController.text,
                      ),
                      weightAndRepsToProblem(
                        weightValid, 
                        repsValid,
                      ),
                      Visibility(
                        visible: setValid == false,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: "If you don't ",
                              ),
                              TextSpan(
                                text: "Fix Your Set",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ", this information will be lost. ",
                              ),
                              TextSpan(
                                text: "Would you like to ",
                              ),
                              TextSpan(
                                text: "Go Back",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " and Fix Your Set?",
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: setValid,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: "But if you don't ",
                              ),
                              TextSpan(
                                text: "Begin Your Set Break",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ", this set will be lost. ",
                              ),
                              TextSpan(
                                text: "Would you like to ",
                              ),
                              TextSpan(
                                text: "Go Back",
                                style: TextStyle( 
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " and Begin Your Set Break?",
                              ),
                            ],
                          ),
                        ),
                      ),
                      //-------------------------Reps-------------------------
                      Transform.translate(
                        offset: Offset(0, 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                goBack(context, true);
                              },
                              child: Text(
                                "No, Delete The Set",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            RaisedButton(
                              color: Colors.blue,
                              //TODO: focus on the first field that is messed up
                              onPressed: (){
                                //pop ourselves
                                Navigator.of(context).pop();

                                //move onto next invalid
                                focusOnFirstInValid(context);
                              },
                              child: Text(
                                "Yes, Go Back",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          onDissmissCallback: (){
            //move onto next invalid
            focusOnFirstInValid(context);
          }
        ).show();

        //don't allow popping automatically
        return false;
      } else {
        goBack(context, alsoPop);
        return true;
      }
    } else {
      goBack(context, alsoPop);
      return true;
    }
  }

  goBack(BuildContext context, bool alsoPop) {
    //may have to unfocus
    FocusScope.of(context).unfocus();
    //animate the header
    App.navSpread.value = false;
    //pop if not using the back button
    if (alsoPop) Navigator.of(context).pop();
  }