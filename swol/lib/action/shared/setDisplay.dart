//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vector_math/vector_math_64.dart' as vect;
import 'package:bot_toast/bot_toast.dart';

//internal: action
import 'package:swol/action/shared/tooltips/repTargetAsPivot.dart';
import 'package:swol/action/shared/tooltips/weightAsPivot.dart';
import 'package:swol/action/shared/tooltips/repsAsPivot.dart';
import 'package:swol/action/shared/tooltips/setToolTips.dart';
import 'package:swol/action/popUps/textValid.dart';
import 'package:swol/action/page.dart';

//internal: other
import 'package:swol/shared/widgets/simple/curvedCorner.dart';
import 'package:swol/shared/widgets/simple/conditional.dart';
import 'package:swol/shared/functions/goldenRatio.dart';
import 'package:swol/shared/structs/anExercise.dart';

//what we use to do the goal set math
enum Pivot { Weight, Reps, RepTarget }

//widget
class SetDisplay extends StatefulWidget {
  const SetDisplay({
    Key key,
    //if its passed then use LAST
    //else use locals updated by stuff all over
    this.exercise,
    //other
    @required this.title,
    this.extraCurvy: false,
    @required this.useAccent,
    //optional
    this.heroUp,
    this.heroAnimTravel,
    this.animate: false,
  }) : super(key: key);

  final AnExercise exercise;
  //other
  final String title;
  final bool extraCurvy;
  final bool useAccent;
  //optional
  final ValueNotifier<bool> heroUp;
  final double heroAnimTravel;
  final bool animate;

  @override
  _SetDisplayState createState() => _SetDisplayState();
}

class _SetDisplayState extends State<SetDisplay> {
  updateState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void initState() {
    //super init
    super.initState();

    //if not exercise passed we may use 1 of three pivots to calculate our goal set
    if (widget.exercise == null) {
      ExercisePage.setGoalWeight.addListener(updateState);
      ExercisePage.setGoalReps.addListener(updateState);
    }

    //change hero position
    if (widget.heroUp != null) {
      widget.heroUp.addListener(updateState);
    }
  }

  @override
  void dispose() {
    //remove change hero position
    if (widget.heroUp != null) {
      widget.heroUp.removeListener(updateState);
    }

    //remove pivot change detectors
    if (widget.exercise == null) {
      ExercisePage.setGoalWeight.removeListener(updateState);
      ExercisePage.setGoalReps.removeListener(updateState);
    }

    //super dipose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<double> defGW = measurementToGoldenRatioBS(250);
    double curveValue = widget.extraCurvy ? 48 : 24;
    double difference = 12;

    Color backgroundColor = widget.useAccent
        ? Theme.of(context).accentColor
        : Theme.of(context).cardColor;
    if (widget.heroUp != null) {
      backgroundColor = widget.heroUp.value
          ? Theme.of(context).accentColor
          : Theme.of(context).cardColor;
    }

    Color foregroundColor =
        widget.useAccent ? Theme.of(context).primaryColorDark : Colors.white;
    if (widget.heroUp != null) {
      foregroundColor = widget.heroUp.value
          ? Theme.of(context).primaryColorDark
          : Colors.white;
    }

    double movementY = 0;
    if (widget.heroUp != null) {
      if (widget.useAccent)
        movementY = widget.heroUp.value ? 0 : widget.heroAnimTravel;
      else
        movementY = widget.heroUp.value ? -widget.heroAnimTravel : 0;
    }

    //what is our pivot
    Pivot goalSetPivot;
    if (widget.exercise == null) {
      //we aren't showing the last set
      if (ExercisePage.pageNumber.value == 0) {
        goalSetPivot = Pivot.RepTarget;
      } else {
        bool weightValid = isTextValid(ExercisePage.setWeight.value);
        double calculatedGoalWeight = ExercisePage?.setGoalWeight?.value ?? 0;
        //NOTE: here we do round since setWeight will ALWAYS BE an integer
        if (weightValid &&
            int.parse(ExercisePage.setWeight.value) ==
                calculatedGoalWeight.round()) {
          //we are using our GOAL WEIGHT as our pivot
          goalSetPivot = Pivot.Weight;
        } else {
          bool repsValid = isTextValid(ExercisePage.setReps.value);
          double calculatedReps = ExercisePage?.setGoalReps?.value ?? 0;
          //NOTE: here we do round since setWeight will ALWAYS BE an integer
          if (repsValid &&
              int.parse(ExercisePage.setReps.value) == calculatedReps.round()) {
            //we are using our GOAL WEIGHT as our pivot
            goalSetPivot = Pivot.Reps;
          } else
            goalSetPivot = Pivot.RepTarget;
        }
      }
    }
    //ELSE we are just show our last set

    //widget
    return AnimatedContainer(
      duration:
          widget.animate ? ExercisePage.transitionDuration : Duration.zero,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(curveValue)),
      ),
      //NOTE: I can't change alignment since that will mess up the FittedBox child
      transform: Matrix4.translation(
        vect.Vector3(
          0,
          movementY,
          0,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: curveValue - difference,
        vertical: difference,
      ),
      child: Material(
        color: Colors.transparent,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            width: 250,
            height: 28,
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 24,
                color: foregroundColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: defGW[1],
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: foregroundColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: defGW[0],
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 4,
                            right: 8,
                          ),
                          child: Container(
                            height: 28,
                            color: foregroundColor,
                            width: 4,
                          ),
                        ),
                        //-------------------------*-------------------------
                        InkWell(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6.0),
                          ),
                          onTap: () {
                            if (goalSetPivot == null) {
                              showWeightToolTip(context,
                                  direction: PreferDirection.topCenter);
                            } else {
                              if (goalSetPivot == Pivot.Weight) {
                                showWeightWeightAsPivotToolTip(context);
                              } else if (goalSetPivot == Pivot.Reps) {
                                showWeightRepsAsPivotToolTip(context);
                              } else
                                showWeightRepTargetAsPivotToolTip(context);
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //-------------------------BELOW
                              Conditional(
                                condition: goalSetPivot != null &&
                                    goalSetPivot == Pivot.Weight,
                                ifTrue: ButtonWrapper(
                                  child: UpdatingSetText(
                                    isWeight: true,
                                    exercise: widget.exercise,
                                  ),
                                  //NOTE: this is correct
                                  backgroundColor: foregroundColor,
                                  foregroundColor: backgroundColor,
                                ),
                                ifFalse: FittedBox(
                                  fit: BoxFit.contain,
                                  child: UpdatingSetText(
                                    isWeight: true,
                                    exercise: widget.exercise,
                                  ),
                                ),
                              ),
                              //-------------------------ABOVE
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(
                                  top: 2,
                                  right: 4,
                                ),
                                child: Icon(
                                  FontAwesomeIcons.dumbbell,
                                  size: 8.5,
                                  color: foregroundColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 1.0,
                          ),
                          child: Icon(
                            FontAwesomeIcons.times,
                            size: 12,
                            color: foregroundColor,
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6.0),
                          ),
                          onTap: () {
                            if (goalSetPivot == null) {
                              showRepsToolTip(context,
                                  direction: PreferDirection.topRight);
                            } else {
                              if (goalSetPivot == Pivot.Weight) {
                                showRepsWeightAsPivotToolTip(context);
                              } else if (goalSetPivot == Pivot.Reps) {
                                showRepsRepsAsPivotToolTip(context);
                              } else
                                showRepsRepTargetAsPivotToolTip(context);
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //-------------------------BELOW
                              Conditional(
                                condition: goalSetPivot != null &&
                                    goalSetPivot != Pivot.Weight,
                                ifTrue: ButtonWrapper(
                                  usingRT: goalSetPivot == Pivot.RepTarget,
                                  child: UpdatingSetText(
                                    isWeight: false,
                                    exercise: widget.exercise,
                                  ),
                                  //NOTE: this is correct
                                  backgroundColor: foregroundColor,
                                  foregroundColor: backgroundColor,
                                ),
                                ifFalse: FittedBox(
                                  fit: BoxFit.contain,
                                  child: UpdatingSetText(
                                    isWeight: false,
                                    exercise: widget.exercise,
                                  ),
                                ),
                              ),
                              //-------------------------ABOVE
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(
                                  top: 2,
                                ),
                                child: Icon(
                                  Icons.repeat,
                                  size: 12,
                                  color: foregroundColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //-------------------------*-------------------------
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UpdatingSetText extends StatelessWidget {
  UpdatingSetText({
    @required this.isWeight,
    this.exercise,
  });

  final AnExercise exercise;
  final bool isWeight;

  @override
  Widget build(BuildContext context) {
    int value;
    if (exercise == null) {
      //NOTE: we CAN round here since the value is simply being used for display
      if (isWeight)
        value = ExercisePage.setGoalWeight.value.round();
      else
        value = ExercisePage.setGoalReps.value.round();
    } else {
      if (isWeight)
        value = exercise.lastWeight;
      else
        value = exercise.lastReps;
    }

    //widget
    return Text(value.toString());
  }
}

class ButtonWrapper extends StatelessWidget {
  ButtonWrapper({
    @required this.child,
    @required this.backgroundColor,
    @required this.foregroundColor,
    this.usingRT: false,
  });

  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool usingRT;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //bottom right black corner
        Positioned(
          bottom: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.only(
              right: 2.0,
            ),
            child: CurvedCorner(
              isTop: false,
              isLeft: false,
              size: 6,
              cornerColor: backgroundColor,
            ),
          ),
        ),
        //the actual button
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(6.0),
            ),
            border: Border.all(
              width: 1,
              color: backgroundColor,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 2,
          ),
          margin: EdgeInsets.only(
            right: 2,
          ),
          child: FittedBox(
            fit: BoxFit.contain,
            child: child,
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.only(
              right: 2.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: FractionalTranslation(
                      translation: Offset(1, 0),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                            width: 24,
                            height: 24,
                            padding: EdgeInsets.only(
                              top: 4,
                              right: 2,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6.0),
                                  bottomRight: Radius.circular(6.0),
                                ),
                              ),
                              padding: EdgeInsets.all(2),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                                child: Conditional(
                                  condition: usingRT,
                                  ifTrue: Text(
                                    "RT",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: foregroundColor,
                                    ),
                                  ),
                                  ifFalse: Icon(
                                    Icons.lock,
                                    color: foregroundColor,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
