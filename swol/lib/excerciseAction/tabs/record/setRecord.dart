//dart
import 'dart:ui';

//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

//internal
import 'package:swol/excerciseAction/tabs/suggest/suggestion/setDisplay.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/cardWithHeader.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/bottomButtons.dart';
import 'package:swol/excerciseAction/tabs/record/changeFunction.dart';
import 'package:swol/excerciseAction/tabs/record/advancedField.dart';
import 'package:swol/excerciseAction/controllersToWidgets.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/methods/theme.dart';

//TODO: the set should also be shown the revert button
//TODO: make sure that we refocus on the problematic field

//widget
class SetRecord extends StatelessWidget {
  SetRecord({
    @required this.excercise,
    @required this.backToSuggestion,
    @required this.setBreak,
    @required this.statusBarHeight,
    @required this.heroUp,
    @required this.heroAnimDuration,
    @required this.heroAnimTravel,
    @required this.weightController,
    @required this.repsController,
  });

  final AnExcercise excercise;
  final Function backToSuggestion;
  final Function setBreak;
  final double statusBarHeight;
  final ValueNotifier<bool> heroUp;
  final Duration heroAnimDuration;
  final double heroAnimTravel;
  final TextEditingController weightController;
  final TextEditingController repsController;

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double appBarHeight = 56; //constant according to flutter docs
    double spaceToRedistribute = fullHeight - appBarHeight - statusBarHeight;

    //color for "suggestion"
    //TODO: because we are wrapped in a white so the pop up works well
    //TODO: this distance color will be white even though it should be the dark card color
    //TODO: fix that... maybe... clean white is kinda cool to
    Color distanceColor = Theme.of(context).cardColor;
    int id = 0;
    if (id == 1)
      distanceColor = Colors.red.withOpacity(0.33);
    else if (id == 2)
      distanceColor = Colors.red.withOpacity(0.66);
    else if (id == 3) distanceColor = Colors.red;

    //build
    return Theme(
      data: MyTheme.dark,
      child: ListView(
        children: <Widget>[
          Container(
            height: spaceToRedistribute,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    //The extra padding that just looked right
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 24,
                          color: Theme.of(context).accentColor,
                        ),
                        Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  )
                                ],
                              ),
                            ),
                            GoalSetWrapped(
                              heroUp: heroUp,
                              heroAnimDuration: heroAnimDuration,
                              heroAnimTravel: heroAnimTravel,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "24",
                                        style: GoogleFonts.robotoMono(
                                          color: distanceColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 96,
                                          wordSpacing: 0,
                                        ),
                                      ),
                                    ),
                                    DefaultTextStyle(
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.percentage,
                                              color: distanceColor,
                                              size: 42,
                                            ),
                                            Text(
                                              "higher",
                                              style: TextStyle(
                                                fontSize: 42,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Transform.translate(
                                  offset: Offset(0, -16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: Text(
                                          "than calculated by the",
                                          style: TextStyle(
                                            fontSize: 22,
                                          ),
                                        ),
                                      ),
                                      ChangeFunction(
                                        excercise: excercise,
                                        middleArrows: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 24.0,
                          ),
                          child: CardWithHeader(
                            header: "Record Set",
                            aLittleSmaller: true,
                            child: RecordFields(
                              weightController: weightController,
                              repController: repsController,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BottomButtons(
                  excercise: excercise,
                  forwardAction: () => maybeError(context),
                  forwardActionWidget: Text(
                    "Take Set Break",
                  ),
                  backAction: backToSuggestion,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //determine whether we should warn the user
  maybeError(BuildContext context) {
    //check data validity
    bool weightValid = weightController.text != "";
    weightValid &= weightController.text != "0";
    bool repsValid = repsController.text != "";
    repsValid &= repsController.text != "0";

    //bring up the pop up if needed
    if ((weightValid && repsValid) == false) {
      //NOTE: this assumes the user CANT type anything except digits of the right size
      bool setValid = weightValid && repsValid;

      //change the buttons shows a the wording a tad
      DateTime startTime = excercise.tempStartTime.value;
      bool timerNotStarted = startTime == AnExcercise.nullDateTime;
      String continueString =
          (timerNotStarted) ? "Begin Your Set Break" : "Return To Your Timer";

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
                    weightAndRepsToDescription(
                      weightController.text,
                      repsController.text,
                      isError: true,
                    ),
                    weightAndRepsToProblem(
                      weightValid,
                      repsValid,
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
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: "\nor "),
                                TextSpan(
                                  text: "Revert",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: " back to, ",
                                ),
                                TextSpan(
                                  text: excercise.tempWeight.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: " for ",
                                ),
                                TextSpan(
                                  text: excercise.tempReps.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "rep" +
                                      (excercise.tempReps == 1 ? "" : "s"),
                                ),
                              ],
                            ),
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
                                    repsController.text =
                                        excercise.tempReps.toString();

                                    //pop ourselves
                                    Navigator.of(context).pop();

                                    //go back to timer
                                    setBreak();
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
                                  //pop ourselves so the user can act
                                  //TODO: focus on the first field that is messed up
                                  onPressed: () => Navigator.of(context).pop(),
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
      setBreak();
    }
  }
}

class GoalSetWrapped extends StatelessWidget {
  const GoalSetWrapped({
    Key key,
    @required this.heroUp,
    @required this.heroAnimDuration,
    @required this.heroAnimTravel,
  }) : super(key: key);

  final ValueNotifier<bool> heroUp;
  final Duration heroAnimDuration;
  final double heroAnimTravel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      child: SetDisplay(
        useAccent: false,
        title: "Goal Set",
        lastWeight: 124,
        lastReps: 23,
        heroUp: heroUp,
        heroAnimDuration: heroAnimDuration,
        heroAnimTravel: heroAnimTravel,
      ),
    );
  }
}
