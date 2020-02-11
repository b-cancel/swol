//flutter
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swol/excerciseAction/controllersToWidgets.dart';
import 'package:swol/excerciseAction/tabs/record/advancedField.dart';
import 'package:swol/excerciseAction/tabs/record/changeFunction.dart';

//internal
import 'package:swol/excerciseAction/tabs/suggest/suggestion/setDisplay.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/cardWithHeader.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/bottomButtons.dart';
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//TODO: because of the cursor, the tooltip menu, and other stuff
//TODO: we need to actually get close to guessing what the text size should be
//TODO: for this we first switch to mono space font and do a test on each character get the size and width of each
//TODO: and how this realtes or changes as font size does
//TODO: so that then for any screen size AND quantity of characters we can guess the width
//TODO: then to make up for the difference that are smaller we use fitted box
//TODO: we also have to convert the whole thing into a list view that contains a container of the size of the max height
//TODO: this will allow the keyboard to scroll the fields into position when they are being editing
//TODO: or preferably I think use Scrollable.ensureVisible

//TODO: use directionality widget to switch start direction "directionality"

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
    DateTime startTime = excercise.tempStartTime.value;
    bool timerNotStarted = startTime == AnExcercise.nullDateTime;
    bool weightValid = weightController.text != "";
    weightValid &= weightController.text != "0";
    bool repsValid = repsController.text != "";
    repsValid &= repsController.text != "0";
    bool weightOrRepsNotEmptyOrZero = weightValid || repsValid;
    bool warningWaranted = timerNotStarted && weightOrRepsNotEmptyOrZero;

    //bring up the pop up if needed
    if (true) { //TODO: use actual condition
      //NOTE: this assumes the user CANT type anything except digits of the right size
      bool setValid = weightValid && repsValid;

      //show the dialog
      AwesomeDialog(
        context: context,
        isDense: true,
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
              "to move onto your set break",
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
                              text: "Repair",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " Your set",
                              style: TextStyle(
                                fontWeight: timerNotStarted ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: " to " 
                              + (timerNotStarted ? "Begin Your Set Break" : "Return To Your Timer")
                            ),
                            TextSpan(
                              text: timerNotStarted ? "" : "\nor "
                            ),
                            TextSpan(
                              text: timerNotStarted ? "" : "Revert",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //TODO: show the values we are going to revert to 
                            TextSpan(
                              text: timerNotStarted ? "" : " back to your previous values",
                            ),
                          ],
                        ),
                      ),
                    ),
                    //TODO: show repair vs back to your previous values buttons ONLY IF
                    //TODO: we have previous values (we know we do if the timer already started)
                  ],
                ),
              ),
            ),
          ],
        ),
      ).show();
    } else{
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
