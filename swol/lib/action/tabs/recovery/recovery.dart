//flutter
import 'package:flutter/material.dart';
import 'package:swol/action/popUps/movePastSetTarget.dart';

//internal: action
import 'package:swol/action/tabs/recovery/secondary/breath.dart';
import 'package:swol/action/tabs/recovery/timer/liquidTime.dart';
import 'package:swol/action/bottomButtons/button.dart';
import 'package:swol/action/popUps/skipTimer.dart';
import 'package:swol/action/page.dart';

//internal: shared
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/widgets/simple/notify.dart';

//widget
class Recovery extends StatefulWidget {
  Recovery({
    @required this.transtionDuration,
    @required this.exercise,
  });

  final Duration transtionDuration;
  final AnExercise exercise;

  @override
  _RecoveryState createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery>
    with SingleTickerProviderStateMixin {
  ValueNotifier<Duration> recoveryDuration;
  ValueNotifier<bool> showAreYouSure;

  //function that is removable from listener
  updateRecoveryDuration() {
    widget.exercise.recoveryPeriod = recoveryDuration.value;

    //cases to test below
    //to shorter one, to longer one, to shorter one after longer completed, to longer one after shorter completed
    scheduleNotification(widget.exercise);
  }

  //init
  @override
  void initState() {
    //setup things to make recovery duration changeable
    recoveryDuration = new ValueNotifier(widget.exercise.recoveryPeriod);
    recoveryDuration.addListener(updateRecoveryDuration);
    showAreYouSure = new ValueNotifier<bool>(true);

    //encourage the user to reap the benefits of the system
    //after everything loads up so nothing crashes IF a pop up is going to be comming up
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //TODO: perhaps use the highlighting notification thing WITHIN the page here
      //NOTE: Im hinting at a certain plugin
      //that is most definately overkill for something so small
      //but... meh... Just in case its an onboarding technique
      askForPermissionIfNotGrantedAndWeNeverAsked(
        context,
        () {
          scheduleNotification(widget.exercise);
        },
      );
    });

    //super init
    super.initState();
  }

  @override
  void dispose() {
    //remove listeners
    recoveryDuration.removeListener(updateRecoveryDuration);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //calc sets passed for bottom buttons
    int setsPassed = (widget.exercise.tempSetCount ?? 0) + 1;

    //color for bottom buttons
    bool lastSetOrBefore = setsPassed <= widget.exercise.setTarget;
    Color buttonsColor = lastSetOrBefore
        ? Theme.of(context).accentColor
        : Theme.of(context).cardColor;

    //build
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        //everything including bottom button and spacing
        children: <Widget>[
          TimerWrapper(
            buttonsColor: buttonsColor,
            child: Timer(
              exercise: widget.exercise,
              timeStarted: widget.exercise.tempStartTime.value,
              changeableTimerDuration: recoveryDuration,
              showAreYouSure: showAreYouSure,
              showIcon: false,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                //24 to clear button
                //extra 24 to clear curve
                bottom: 24.0, // + 24,
              ),
              child: Container(
                //color: Colors.blue,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: ToBreath(),
                  ),
                ),
              ),
            ),
          ),
          Theme(
            data: MyTheme.light,
            child: RecoveryButtonsWithWhiteContext(
              transitionDuration: widget.transtionDuration,
              showAreYouSure: showAreYouSure,
              buttonsColor: buttonsColor,
              exercise: widget.exercise,
              setsPassed: setsPassed,
              headerColor: Theme.of(context).cardColor,
            ),
          )
        ],
      ),
    );
  }
}

class TimerWrapper extends StatelessWidget {
  const TimerWrapper({
    Key key,
    @required this.buttonsColor,
    @required this.child,
  }) : super(key: key);

  final Color buttonsColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Container(
                  color: buttonsColor,
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: (buttonsColor == Theme.of(context).accentColor) ? 16 : 0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

class RecoveryButtonsWithWhiteContext extends StatelessWidget {
  const RecoveryButtonsWithWhiteContext({
    Key key,
    @required this.transitionDuration,
    @required this.showAreYouSure,
    @required this.buttonsColor,
    @required this.exercise,
    @required this.setsPassed,
    @required this.headerColor,
  }) : super(key: key);

  final Duration transitionDuration;
  final ValueNotifier<bool> showAreYouSure;
  final Color buttonsColor;
  final AnExercise exercise;
  final int setsPassed;
  final Color headerColor;

  @override
  Widget build(BuildContext context) {
    return BottomButtons(
      color: buttonsColor,
      exerciseID: exercise.id,
      forwardAction: () {
        if (exercise.tempStartTime.value != AnExercise.nullDateTime) {
          Function ifMoveToNextSet = () {
            if (showAreYouSure.value) {
              maybeSkipTimer(
                context,
                exercise,
                goToNextSet,
                headerColor,
                exercise.tempStartTime.value,
              );
            } else {
              goToNextSet();
            }
          };

          //NOTE: we only bother the user if they match
          //because we are warning the user that they are going above their target
          int target = exercise.setTarget;
          int current = exercise.tempSetCount;
          if (target == current) {
            movePastSetTarget(
              context,
              ifMoveToNextSet,
              target,
              headerColor,
            );
          } else {
            ifMoveToNextSet();
          }
        }
        //ELSE: the button was Accidentally quick tapped
      },
      forwardActionWidget: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Begin",
            ),
            TextSpan(
              text: " Set " + setsPassed.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            TextSpan(
              text: "/" + exercise.setTarget.toString(),
            ),
          ],
        ),
      ),
      backAction: () {
        ExercisePage.pageNumber.value = 1;
      },
    );
  }

  goToNextSet() {
    //will also handle navigation
    ExercisePage.nextSet.value = true;
  }
}
