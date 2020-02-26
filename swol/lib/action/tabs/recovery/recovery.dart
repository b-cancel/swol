//flutter
import 'package:flutter/material.dart';
import 'package:swol/action/popUps/skipTimer.dart';

//internal: action
import 'package:swol/action/tabs/recovery/secondary/breath.dart';
import 'package:swol/action/tabs/recovery/timer/liquidTime.dart';
import 'package:swol/action/bottomButtons/button.dart';
import 'package:swol/action/page.dart';
import 'package:swol/shared/methods/theme.dart';

//internal: shared
import 'package:swol/shared/structs/anExcercise.dart';

//widget
class Recovery extends StatefulWidget {
  Recovery({
    @required this.transtionDuration,
    @required this.excercise,
  });

  final Duration transtionDuration;
  final AnExcercise excercise;

  @override
  _RecoveryState createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery>
    with SingleTickerProviderStateMixin {
  ValueNotifier<Duration> recoveryDuration;
  ValueNotifier<bool> showAreYouSure;

  //function that is removable from listener
  updateRecoveryDuration() {
    widget.excercise.recoveryPeriod = recoveryDuration.value;
  }

  //init
  @override
  void initState() {
    //setup things to make recovery duration changeable
    recoveryDuration = new ValueNotifier(widget.excercise.recoveryPeriod);
    recoveryDuration.addListener(updateRecoveryDuration);
    showAreYouSure = new ValueNotifier<bool>(true);

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
    int setsPassed = (widget.excercise.tempSetCount ?? 0) + 1;

    //color for bottom buttons
    bool lastSetOrBefore = setsPassed <= widget.excercise.setTarget;
    Color buttonsColor =  lastSetOrBefore ? Theme.of(context).accentColor : Theme.of(context).cardColor;

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
              excercise: widget.excercise,
              timeStarted: widget.excercise.tempStartTime.value,
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
              excercise: widget.excercise,
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
    @required this.excercise,
    @required this.setsPassed,
    @required this.headerColor,
  }) : super(key: key);

  final Duration transitionDuration;
  final ValueNotifier<bool> showAreYouSure;
  final Color buttonsColor;
  final AnExcercise excercise;
  final int setsPassed;
  final Color headerColor;

  @override
  Widget build(BuildContext context) {
    return BottomButtons(
      color: buttonsColor,
      excerciseID: excercise.id,
      forwardAction: () {
        if(showAreYouSure.value){
          maybeSkipTimer( 
            context, 
            excercise, 
            goToNextSet,
            headerColor,
          );
        }
        else goToNextSet();
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
              text: "/" + excercise.setTarget.toString(),
            ),
          ],
        ),
      ),
      backAction: (){
        ExcercisePage.pageNumber.value = 1;
      },
    );
  }

  goToNextSet(){
    //will also handle navigation
    ExcercisePage.nextSet.value = true;
  }
}