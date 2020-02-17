//flutter
import 'package:flutter/material.dart';
import 'package:swol/action/popUps/skipTimer.dart';

//internal: action
import 'package:swol/action/tabs/recovery/secondary/breath.dart';
import 'package:swol/action/tabs/recovery/timer/liquidTime.dart';
import 'package:swol/action/bottomButtons/button.dart';
import 'package:swol/action/page.dart';

//internal: shared
import 'package:swol/shared/structs/anExcercise.dart';

//widget
class Recovery extends StatefulWidget {
  Recovery({
    @required this.excercise,
  });

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
    Radius cardRadius = Radius.circular(24);

    //calc sets passed for bottom buttons
    int setsPassed = widget.excercise.tempSetCount.value + 1;

    //color for bottom buttons
    bool lastSetOrBefore = setsPassed <= widget.excercise.setTarget.value;
    Color buttonsColor =  lastSetOrBefore ? Theme.of(context).accentColor : Theme.of(context).cardColor;

    //build
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        //everything including bottom button and spacing
        children: <Widget>[
          Stack(
            children: [
              Positioned.fill(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.all(cardRadius),
                  ),
                  child: Timer(
                    excercise: widget.excercise,
                    changeableTimerDuration: recoveryDuration,
                    showAreYouSure: showAreYouSure,
                    showIcon: false,
                  ),
                ),
              ),
            ],
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
          BottomButtons(
            color: buttonsColor,
            excercise: widget.excercise,
            forwardAction: () {
              if(showAreYouSure.value){
                maybeSkipTimer(
                  context, 
                  widget.excercise, 
                  goToNextSet,
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
                    text: "/" + widget.excercise.setTarget.value.toString(),
                  ),
                ],
              ),
            ),
            backAction: (){
              ExcercisePage.pageNumber.value = 1;
            },
          )
        ],
      ),
    );
  }

  goToNextSet(){
    //move onto next set
    ExcercisePage.nextSet.value = true;
    //move onto the next set
    ExcercisePage.pageNumber.value = 0;
  }
}