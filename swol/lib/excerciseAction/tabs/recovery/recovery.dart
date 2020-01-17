import 'package:flutter/material.dart';
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excerciseAction/tabs/recovery/secondary/breath.dart';
import 'package:swol/excerciseAction/tabs/recovery/timer/liquidTime.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/bottomButtons.dart';
import 'package:swol/excerciseAction/tabs/suggest/suggest.dart';

class Recovery extends StatefulWidget {
  Recovery({
    @required this.excerciseID,
    @required this.backToRecordSet,
    @required this.nextSet,
  });

  final int excerciseID;
  final Function backToRecordSet;
  final Function nextSet;

  @override
  _RecoveryState createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> with SingleTickerProviderStateMixin {
  //the time our timer starts that doesn't change
  DateTime timerStart;
  bool timerJustStarted;

  //so we can update our excercises duration
  ValueNotifier<Duration> recoveryDuration;

  //function that is removable from listener
  updateRecoveryDuration(){
    ExcerciseData.updateExcercise(
      widget.excerciseID,
      recoveryPeriod: recoveryDuration.value,
    );
  }

  //init
  @override
  void initState() {
    DateTime currentTimerStart = ExcerciseData.getExcercises().value[widget.excerciseID].tempStartTime;

    //based on whether or not the timer has already started set the timerStart
    if(currentTimerStart == null){
      ExcerciseData.updateExcercise(
        widget.excerciseID,
        tempStartTime: DateTime.now(),
      );
      timerStart = DateTime.now();
    }
    else timerStart = currentTimerStart;
    
    //set recovery duration init
    recoveryDuration = new ValueNotifier(
      ExcerciseData.getExcercises().value[widget.excerciseID].recoveryPeriod,
    );

    //if recovery duration changes we must update it
    recoveryDuration.addListener(updateRecoveryDuration);

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  //NOTE: how this is 0
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.green,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        LiquidTime(
                          changeableTimerDuration: recoveryDuration,
                          timerStart: timerStart,
                          showIcon: false,
                        ),
                        ToBreath(),
                      ],
                    ),
                  )
                ),
              ),
              BottomButtonPadding()
            ],
          ),

          /*
          
          */
          
          
          /*Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: 16,
                ),
                child: LiquidTime(
                  changeableTimerDuration: recoveryDuration,
                  timerStart: timerStart,
                  showIcon: false,
                ),
              ),
              Expanded(
                child: ToBreath(),
              )
            ],
          )
          */
        ),
        BottomButtons(
          forwardAction: (){
            //move onto the next set
            widget.nextSet();

            //zero out the tempStartTimer
            ExcerciseData.updateExcercise(
              widget.excerciseID,
              tempStartTimeCanBeNull: true,
              tempStartTime: null,
            );
          },
          forwardActionWidget: Text(
            "Next Set",
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          backAction: widget.backToRecordSet,
        )
      ],
    );
  }
}