import 'package:flutter/material.dart';
import 'package:swol/sharedWidgets/timePicker.dart';
import 'package:swol/sharedWidgets/trainingTypes/trainingTypes.dart';

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

class ChangeRecoveryTimeWidget extends StatefulWidget {
  ChangeRecoveryTimeWidget({
    Key key,
    @required this.changeDuration,
    @required this.recoveryPeriod,
  }) : super(key: key);

  final Duration changeDuration;
  final ValueNotifier<Duration> recoveryPeriod;

  @override
  _ChangeRecoveryTimeWidgetState createState() => _ChangeRecoveryTimeWidgetState();
}

class _ChangeRecoveryTimeWidgetState extends State<ChangeRecoveryTimeWidget> {
  ValueNotifier<int> sectionID = new ValueNotifier(0);

  recoveryPeriodToSectionID(){
    if(widget.recoveryPeriod.value < Duration(seconds: 15)) sectionID.value = 0; //nothing
    else{
      if(widget.recoveryPeriod.value <= Duration(minutes: 1)) sectionID.value = 1; //endurance
      else{
        if(widget.recoveryPeriod.value <= Duration(minutes: 2)) sectionID.value = 2; //hypertrophy
        else{
          if(widget.recoveryPeriod.value < Duration(minutes: 3)) sectionID.value = 3; //hypertrophy/strength
          else sectionID.value = 4;
        }
      }
    }
  }

  @override
  void initState() {
    //initial function calls
    recoveryPeriodToSectionID();

    //as the recovery period changes updates should occur
    widget.recoveryPeriod.addListener(recoveryPeriodToSectionID);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    widget.recoveryPeriod.removeListener(recoveryPeriodToSectionID);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Theme(
              data: ThemeData.dark(),
              child: TrainingTypeSections(
                lightMode: true,
                highlightField: 2,
                //nothing / endurance / hypertrohpy / hypertrophy & strength / strength and above
                sections: [[0], [0], [1], [1,2], [2]],
                sectionID: sectionID,
                plus24: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              children: <Widget>[
                TimePicker(
                  duration: widget.recoveryPeriod,
                  darkTheme: false,
                ),
                MinsSecsBelowTimePicker(
                  duration: widget.recoveryPeriod,
                  darkTheme: false,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}