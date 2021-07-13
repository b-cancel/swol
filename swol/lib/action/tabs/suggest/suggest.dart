//flutter
import 'package:flutter/material.dart';

//internal: action
import 'package:swol/action/tabs/suggest/changeSuggestion.dart';
import 'package:swol/action/bottomButtons/button.dart';
import 'package:swol/action/shared/halfColored.dart';
import 'package:swol/action/shared/setDisplay.dart';
import 'package:swol/action/page.dart';
import 'package:swol/other/functions/W&R=1RM.dart';
import 'package:swol/other/functions/helper.dart';

//internal: other
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/other/functions/1RM&R=W.dart';

//widget
class Suggestion extends StatefulWidget {
  Suggestion({
    required this.exercise,
    required this.heroUp,
    required this.heroAnimTravel,
  });

  final AnExercise exercise;
  final ValueNotifier<bool> heroUp;
  final double heroAnimTravel;

  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  //set target set
  final ValueNotifier<int> repTarget = new ValueNotifier<int>(0);

  //update the goal set based on init
  //and changed valus
  updateGoalWeight() {
    print("last weight: " + (widget.exercise.lastWeight?.toString() ?? "N/A"));
    print("last reps: " + (widget.exercise.lastReps?.toString() ?? "N/A"));
    double lastWeight = widget.exercise.lastWeight!.toDouble();
    int lastReps = widget.exercise.lastReps!;

    //calculate all possible 1RMS
    List<double> oneRMs = Functions.getOneRepMaxValues(
      lastWeight.toInt(),
      lastReps,
      onlyIfNoBackUp: false,
    )[0];

    //maxes, mean, std deviation
    List otherMaxes = Functions.getXRepMaxValues(
      ExercisePage.setGoalReps.value.toInt(),
      oneRMs,
    );

    //grab correct goal weight
    ExercisePage.setGoalWeight.value = otherMaxes[1];
    ExercisePage.setGoalPlusMinus.value = otherMaxes[2];
    print(ExercisePage.setGoalWeight.value.toInt().toString() +
        "+/-" +
        ExercisePage.setGoalPlusMinus.value.toInt().toString() +
        ' for ' +
        ExercisePage.setGoalReps.value.toString() +
        " reps");
  }

  updateRepTarget() {
    //update it in the file
    widget.exercise.repTarget = repTarget.value;
    //update it locally
    ExercisePage.setGoalReps.value = repTarget.value.toDouble();

    //update the goal by chosing from everything we
    updateGoalWeight();
  }

  @override
  void initState() {
    //super init
    super.initState();

    //set inits
    repTarget.value = widget.exercise.repTarget;
    updateRepTarget();
    repTarget.addListener(updateRepTarget);
  }

  @override
  void dispose() {
    repTarget.removeListener(updateRepTarget);
    repTarget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //card radius
    Radius arrowRadius = Radius.circular(48);
    Radius cardRadius = Radius.circular(24);

    //calc sets passed for bottom buttons
    int setsPassed = widget.exercise.tempSetCount ?? 0;
    //TODO: this should still work since if we are in the suggest page & our timer isn't null
    //that should only be because our set was valid and we didn't reset it when comming from record
    bool timerNotStarted =
        widget.exercise.tempStartTime.value == AnExercise.nullDateTime;
    if (timerNotStarted) setsPassed += 1;

    //color for bottom buttons
    bool lastSetOrBefore = setsPassed <= widget.exercise.setTarget;
    Color buttonsColor = lastSetOrBefore
        ? Theme.of(context).accentColor
        : Theme.of(context).cardColor;

    //build
    return ClipRRect(
      //clipping so "hero" doesn't show up in the other page
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        child: CustomScrollView(
                          physics: BouncingScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: Container(
                                color: Colors.black,
                                child: TopBackgroundColored(
                                  color: Theme.of(context).cardColor,
                                  child: SetDisplay(
                                    exercise: widget.exercise,
                                    useAccent: false,
                                    extraCurvy: true,
                                    title: "Last Set",
                                  ),
                                ),
                              ),
                            ),
                            SliverFillRemaining(
                              hasScrollBody: false,
                              fillOverscroll: true,
                              child: Container(
                                color: Colors.black,
                                child: Center(
                                  child: DefaultTextStyle(
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Container(
                                        height: 56,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "under the same conditions",
                                            ),
                                            Container(
                                              height: 2,
                                            ),
                                            Text(
                                              "as your last set",
                                            ),
                                            Container(
                                              height: 2,
                                            ),
                                            Text(
                                              "you should be able to lift",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SuggestionChanger(
                      repTarget: repTarget,
                      cardRadius: cardRadius,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            //for done button curve
            padding: EdgeInsets.only(
              top: 24,
            ),
            child: BottomButtons(
              color: buttonsColor,
              exerciseID: widget.exercise.id,
              forwardAction: () {
                //move to page 1
                ExercisePage.pageNumber.value = 1;

                //start the timer IF it hasn't been started already
                bool timerStarted = (widget.exercise.tempStartTime.value !=
                    AnExercise.nullDateTime);
                if (timerStarted == false) {
                  //start timer
                  ExercisePage.toggleTimer.value = true;
                }
              },
              forwardActionWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timerNotStarted ? "Record" : "View",
                  ),
                  Text(
                    " Set " + setsPassed.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "/" + widget.exercise.setTarget.toString(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
