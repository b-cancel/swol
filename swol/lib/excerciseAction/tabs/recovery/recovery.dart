import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swol/excerciseAction/tabs/recovery/breath.dart';
import 'package:swol/excerciseAction/tabs/recovery/liquidStopwatch.dart';
import 'package:swol/excerciseAction/tabs/recovery/liquidTimer.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/done.dart';
import 'package:swol/excerciseAddition/addExcercise.dart';

class Recovery extends StatefulWidget {
  Recovery({
    @required this.recoveryDuration,
  });

  final ValueNotifier<Duration> recoveryDuration;

  @override
  _RecoveryState createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> with SingleTickerProviderStateMixin {
  //primary vars
  DateTime timerStart;

  //init
  @override
  void initState() {
    //record the time the timer started
    timerStart = DateTime.now();

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color secondaryColorOne =  Color(0xFFBFBFBF);
    Color accentTimer = Theme.of(context).accentColor;
    Color accentStopwatch = Colors.red;
    Color secondaryColorTwo = Colors.white; 

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
                            changeableTimerDuration: widget.recoveryDuration,
                            timerStart: timerStart,
                            waveColor: accentStopwatch,
                            backgroundColor: secondaryColorOne,
                            maxExtraDuration: Duration(minutes: 4),
                          ),
                          //---The main countdown timer
                          LiquidTimer(
                            changeableTimerDuration: widget.recoveryDuration,
                            timerStart: timerStart,
                            backgroundColor: secondaryColorOne,
                            waveColor: accentTimer,
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
            BottomButtons()
          ],
        ),
      ),
    );
  }
}

class ToBreath extends StatelessWidget {
  const ToBreath({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context, 
          PageTransition(
            type: PageTransitionType.fade, 
            child: Breath(),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(
          16,
        ),
        child: Container(
          width: 50,
          height: 50,
          child: Hero(
            tag: 'breath',
            child: new Image(
              image: new AssetImage("assets/gifs/breathMod.gif"),
              //lines being slightly distinguishable is ugly
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}

class BottomButtons extends StatelessWidget {
  const BottomButtons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          DoneButton(),
          Expanded(
            child: Container(),
          ),
          FlatButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text("Back"),
          ),
          //both paddings + button size
          //height: (16 * 2) + 48.0,
          RaisedButton(
            color: Theme.of(context).accentColor,
            textColor: Theme.of(context).primaryColor,
            onPressed: (){
              Navigator.pop(context);
            },
            //TODO: if our next set will go above our targer alert the user of this 
            //TODO:  and ask if they want to proceed or end
            child: Text("Next Set"),
          ),
        ],
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
              child: RecoveryTimeWidget(
                changeDuration: Duration(milliseconds: 250), 
                sliderWidth: MediaQuery.of(context).size.width, 
                textHeight: 16, 
                textMaxWidth: 28, 
                recoveryPeriod: possibleRecoveryDuration, 
                darkTheme: false,
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