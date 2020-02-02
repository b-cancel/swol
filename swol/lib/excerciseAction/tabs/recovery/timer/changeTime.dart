//flutter
import 'package:flutter/material.dart';

//internal: time picker
import 'package:swol/shared/widgets/complex/trainingTypeTables/trainingTypes.dart';
import 'package:swol/shared/widgets/complex/RecoveryTime/minSecs.dart';
import 'package:swol/shared/widgets/complex/recoveryTime/picker.dart';
import 'package:swol/shared/methods/theme.dart';

//allows user to change the time visually without actually changing it UNTIL they click confirm
maybeChangeTime({
  @required BuildContext context,
  @required ValueNotifier<Duration> recoveryDuration,
  }){
  ValueNotifier<Duration> possibleRecoveryDuration = new ValueNotifier(recoveryDuration.value);
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return ChangeRecoveryTimePopUp(
        possibleRecoveryDuration: possibleRecoveryDuration,
        recoveryDuration: recoveryDuration,
      ); 
    },
  );
}

//the outer shell of the pop up and the confirm and cancel buttons
class ChangeRecoveryTimePopUp extends StatelessWidget {
  const ChangeRecoveryTimePopUp({
    Key key,
    @required this.possibleRecoveryDuration,
    @required this.recoveryDuration,
  }) : super(key: key);

  final ValueNotifier<Duration> possibleRecoveryDuration;
  final ValueNotifier<Duration> recoveryDuration;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MyTheme.light,
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
        contentPadding: EdgeInsets.all(0),
        content: ChangeRecoveryTimeWidget(
          changeDuration: Duration(milliseconds: 250), 
          recoveryPeriod: possibleRecoveryDuration, 
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
  }
}

//the main beef and content that switches or slides between the different options as the user edits the setting
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
              data: MyTheme.dark,
              child: FittedBox(
                fit: BoxFit.contain,
                child: TrainingTypeSections(
                  cardBackground: false,
                  highlightField: 2,
                  //nothing / endurance / hypertrohpy / hypertrophy & strength / strength and above
                  sections: [[0], [0], [1], [1,2], [2]],
                  sectionID: sectionID,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              children: <Widget>[
                RecoveryTimePicker(
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