import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:swol/action/page.dart';
import 'package:swol/action/popUps/reusable.dart';
import 'package:swol/shared/structs/anExcercise.dart';

/*
maybeError(BuildContext context, AnExcercise excercise) {
    //handle weight
    String weight = ExcercisePage.setWeight.value;
    bool weightValid =  weight != "" && weight != "0";

    //hanlde reps
    String reps = ExcercisePage.setReps.value;
    bool repsValid = reps != "" && reps != "0";

    //bring up the pop up if needed
    if ((weightValid && repsValid) == false) {
      //NOTE: this assumes the user CANT type anything except digits of the right size
      bool setValid = weightValid && repsValid;

      //change the buttons shows a the wording a tad
      DateTime startTime = excercise.tempStartTime.value;
      bool timerNotStarted = startTime == AnExcercise.nullDateTime;
      String continueString =
          (timerNotStarted) ? "Begin Your Set Break" : "Return To Your Timer";

      //remove focus so the pop up doesnt bring it back
      FocusScope.of(context).unfocus();

      //show the dialog
      AwesomeDialog(
        context: context,
        dismissOnTouchOutside: true,
        dialogType: DialogType.ERROR,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: false,
        body: Column(
          children: [
            Text(
              "Fix Your Set",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            Text(
              "To " + continueString,
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
                    SetDescription(
                      weight: weight,
                      reps: reps,
                      isError: true,
                    ),
                    SetProblem(
                      weightValid: weightValid,
                      repsValid: repsValid,
                      setValid: setValid,
                      isError: true,
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
                              text: "Fix",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " Your Set",
                              style: TextStyle(
                                fontWeight: timerNotStarted
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: " to " + continueString,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: timerNotStarted == false,
                      child: Column(
                        children: <Widget>[
                          RevertToPrevious(
                            excercise: excercise,
                          ),
                          //-------------------------Butttons-------------------------
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
                                    //revert back
                                    weightController.text =
                                        excercise.tempWeight.toString();
                                    widget.repsController.text =
                                        widget.excercise.tempReps.toString();

                                    //pop ourselves
                                    Navigator.of(context).pop();

                                    //go back to timer
                                    widget.setBreak();
                                  },
                                  child: Text(
                                    "Revert Back",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                RaisedButton(
                                  color: Colors.blue,
                                  onPressed: (){
                                    //pop ourselves
                                    Navigator.of(context).pop();
                                    //either one, or both values are valid
                                    //if both are valid, nothing happens
                                    widget.focusOnFirstInValid();
                                  },
                                  child: Text(
                                    "Let Me Fix It",
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ).show();
    } else {
      widget.setBreak();
    }
  }
  */