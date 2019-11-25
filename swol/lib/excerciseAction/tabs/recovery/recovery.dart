import 'package:flutter/material.dart';
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excerciseAction/tabs/recovery/secondary/breath.dart';
import 'package:swol/excerciseAction/tabs/recovery/timer/liquidTime.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/bottomButtons.dart';

class Recovery extends StatefulWidget {
  Recovery({
    @required this.excerciseID,
    @required this.allSetsComplete,
    @required this.backToRecordSet,
    @required this.nextSet,
  });

  final int excerciseID;
  final Function allSetsComplete;
  final Function backToRecordSet;
  final Function nextSet;

  @override
  _RecoveryState createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> with SingleTickerProviderStateMixin {
  //the time our timer starts that doesn't change
  DateTime timerStart;

  //so we can update our excercises duration
  ValueNotifier<Duration> recoveryDuration;

  //init
  @override
  void initState() {
    //TODO: this should only not be read from the data structure
    //TODO: IF timerStart is empty is the data structure
    //record the time the timer started
    timerStart = DateTime.now();
    
    //set recovery duration init
    //NOTE: assume we have this excercise ID
    recoveryDuration = new ValueNotifier(
      ExcerciseData.getExcercises().value[widget.excerciseID].recoveryPeriod,
    );

    //if recovery duration changes we must update it
    recoveryDuration.addListener((){
      ExcerciseData.updateExcercise(
        widget.excerciseID,
        recoveryPeriod: recoveryDuration.value,
      );
    });

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      LiquidTime(
                        changeableTimerDuration: recoveryDuration,
                        timerStart: timerStart,
                        maxDuration: Duration(minutes: 5),
                      ),
                      ToBreath(),
                    ],
                  ),
                ),
              )
            ),
            BottomButtons(
              allSetsComplete: widget.allSetsComplete,
              forwardAction: widget.nextSet,
              forwardActionWidget: Text("Next Set"),
              backAction: widget.backToRecordSet,
            )
          ],
        ),
      ),
    );
  }
}