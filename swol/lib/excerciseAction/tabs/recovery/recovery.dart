import 'package:flutter/material.dart';
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excerciseAction/tabs/recovery/changeTime.dart';
import 'package:swol/excerciseAction/tabs/recovery/liquidStopwatch.dart';
import 'package:swol/excerciseAction/tabs/recovery/liquidTimer.dart';
import 'package:swol/excerciseAction/tabs/recovery/secondary/breath.dart';
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
  //TODO: this should get written into the excercise
  DateTime timerStart;

  //so we can update our excercises duration
  ValueNotifier<Duration> recoveryDuration;

  //init
  @override
  void initState() {
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
    //-------------------------settings to play with--------------------

    //Colors
    Color secondaryColorOne =  Color(0xFFBFBFBF);
    Color accentTimer = Theme.of(context).accentColor;
    Color accentStopwatch = Colors.red;

    //other
    bool showArrows = true;
    bool showIcon = true;

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
                      //---Actually Animated Stuff
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          //---White Backgrond circle
                          //---The secondary
                          LiquidStopwatch(
                            changeableTimerDuration: recoveryDuration,
                            timerStart: timerStart,
                            waveColor: accentStopwatch,
                            backgroundColor: secondaryColorOne,
                            maxExtraDuration: Duration(minutes: 5),
                            showArrows: showArrows,
                            showIcon: showIcon,
                          ),
                          //---The main countdown timer
                          LiquidTimer(
                            changeableTimerDuration: recoveryDuration,
                            timerStart: timerStart,
                            backgroundColor: secondaryColorOne,
                            waveColor: accentTimer,
                            showArrows: showArrows,
                            showIcon: showIcon,
                          ),
                        ],
                      ),
                      //---Pretend Animated Stuff
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

maybeChangeTime({
  @required BuildContext context,
  @required ValueNotifier<Duration> recoveryDuration,
  }){
    ValueNotifier<Duration> possibleRecoveryDuration = new ValueNotifier(recoveryDuration.value);
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            contentPadding: EdgeInsets.all(0),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Change Break Time",
                ),
                Text(
                  "Don't Worry! The Timer Won't Reset",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                )
              ],
            ),
            content: Container(
              child: ChangeRecoveryTimeWidget(
                changeDuration: Duration(milliseconds: 250), 
                recoveryPeriod: possibleRecoveryDuration, 
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              RaisedButton(
                color: Colors.blue,
                onPressed: (){
                  recoveryDuration.value = possibleRecoveryDuration.value;
                  Navigator.pop(context);
                },
                child: Text(
                  "Change",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ); 
      },
    );
  }