import 'package:flutter/material.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/bottomButtons.dart';
import 'package:swol/excerciseAction/tabs/recovery/secondary/breath.dart';
import 'package:swol/excerciseAction/tabs/recovery/timer/liquidTime.dart';
import 'package:swol/shared/structs/anExcercise.dart';

class Recovery extends StatefulWidget {
  Recovery({
    @required this.excercise,
    @required this.backToRecordSet,
    @required this.nextSet,
  });

  final AnExcercise excercise;
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
    widget.excercise.recoveryPeriod = recoveryDuration.value;
  }

  //init
  @override
  void initState() {
    DateTime currentTimerStart = widget.excercise.tempStartTime.value;

    //based on whether or not the timer has already started set the timerStart
    if(currentTimerStart == AnExcercise.nullDateTime){
      widget.excercise.tempStartTime = new ValueNotifier<DateTime>(DateTime.now());
      timerStart = DateTime.now();
    }
    else timerStart = currentTimerStart;
    
    //set recovery duration init
    recoveryDuration = new ValueNotifier(
      widget.excercise.recoveryPeriod,
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
    Radius cardRadius = Radius.circular(24);

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        //everything including bottom button and spacing
        children: <Widget>[
          PreviousCardCorners(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: cardRadius,
                      bottomRight: cardRadius,
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Hero(
                      tag: "timer" + widget.excercise.id.toString(),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                        ),
                      )
                      
                      
                      /*LiquidTime(
                        excercise: widget.excercise,
                        changeableTimerDuration: recoveryDuration,
                        timerStart: timerStart,
                        showIcon: false,
                      ),*/
                    ),
                  )
                ),
              ],
            ), 
            cardRadius: cardRadius,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                //24 to clear button
                //extra 24 to clear curve
                bottom: 24.0,// + 24,
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
            excercise: widget.excercise,
            forwardAction: (){
              //move onto the next set
              widget.nextSet();

              //zero out the tempStartTimer
              widget.excercise.tempStartTime = new ValueNotifier<DateTime>(AnExcercise.nullDateTime);
            },
            forwardActionWidget: Text(
              "Next Set",
            ),
            backAction: widget.backToRecordSet,
          )
        ],
      ),
    );
  }
}

class PreviousCardCorners extends StatelessWidget {
  const PreviousCardCorners({
    Key key,
    @required this.child,
    @required this.cardRadius,
  }) : super(key: key);

  final Widget child;
  final Radius cardRadius;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 16,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).accentColor,
        ),
        Stack(
          children: <Widget>[
            child,
            //-------------------------Top Left-------------------------
            Positioned(
              top: 0,
              left: 0,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: cardRadius,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: cardRadius,
                        bottomRight: cardRadius,
                      ),
                    ),
                    height: 25,
                    width: 25,
                  ),
                ],
              ),
            ),
            //-------------------------Top Right-------------------------
            Positioned(
              top: 0,
              right: 0,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    //NOTE: in order for smooth blend 
                    //notice the difference alos between 24 and 25 size
                    right: 0, 
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: cardRadius,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        topRight: cardRadius,
                        bottomLeft: cardRadius,
                      ),
                    ),
                    height: 25,
                    width: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}