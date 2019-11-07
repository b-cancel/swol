import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swol/excerciseAction/tabs/recovery/breath.dart';
import 'package:swol/excerciseAction/tabs/recovery/liquidIndicators.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/done.dart';
import 'package:swol/sharedWidgets/timePicker.dart';

//TODO: 0 -> 60 seconds: Endurance
//TODO: 60 -> 2 minutes: Mass
//TODO: 2 -> 3: Mass/Strength
//TODO: 3 -> 5: Strength

class Recovery extends StatefulWidget {
  Recovery({
    @required this.recoveryDuration,
  });

  final ValueNotifier<Duration> recoveryDuration;

  @override
  _RecoveryState createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> with SingleTickerProviderStateMixin {
  ValueNotifier<Duration> longestDuration = new ValueNotifier<Duration>(Duration(minutes: 5));

  //primary vars
  DateTime timerStart;

  //before changing fullDuration we let the picker change this
  ValueNotifier<Duration> possibleFullDuration = new ValueNotifier(Duration.zero);

  //init
  @override
  void initState() {
    //TODO: use the timer start of the object
    //record the time the timer started
    timerStart = DateTime.now();

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //size the liquid loader
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double size = (width < height) ? width : height;

    //build
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                      bottom: 8
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Text(
                        "Eliminating Lactic Acid Build-Up",
                        //Ready For Next Set
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                height: size,
                width: size,
                padding: EdgeInsets.all(24),
                child: Stack(
                  children: <Widget>[
                    /*
                    LiquidCountDown(
                      changeableTimerDuration: longestDuration,
                      timerStart: timerStart,
                    ),
                    */
                    LiquidCountDown(
                      possibleFullDuration: possibleFullDuration,
                      changeableTimerDuration: widget.recoveryDuration,
                      timerStart: timerStart,
                      //size of entire bubble = size container - padding for each size
                      centerSize: size - (24 * 2),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: InkWell(
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
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
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
            )
          ],
        ),
      ),
    );
  }
}

maybeChangeTime({
  @required BuildContext context,
  @required ValueNotifier<Duration> possibleFullDuration,
  @required ValueNotifier<Duration> recoveryDuration,
  }){
    possibleFullDuration.value = recoveryDuration.value;

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
              child: TimePicker(
                duration: possibleFullDuration,
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
                onPressed: (){
                  recoveryDuration.value = possibleFullDuration.value;
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