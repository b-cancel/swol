//flutter
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:swol/pages/add/widgets/recoveryTime.dart';

//internal: time picker
import 'package:swol/shared/widgets/complex/trainingTypeTables/trainingTypes.dart';
import 'package:swol/shared/widgets/complex/RecoveryTime/minSecs.dart';
import 'package:swol/shared/widgets/complex/recoveryTime/picker.dart';
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/widgets/simple/ourLearnPopUp.dart';

class ActualButton extends StatelessWidget {
  const ActualButton({
    Key key,
    @required this.color,
    @required this.changeableTimerDuration,
  }) : super(key: key);

  final Color color;
  final ValueNotifier<Duration> changeableTimerDuration;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<Duration> possibleRecoveryDuration =
        new ValueNotifier<Duration>(
      changeableTimerDuration.value,
    );

    return InkWell(
      onTap: () {
        showCustomPopUp(
          context,
          [
            Text(
              "Change Break Time",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            Text(
              "Don't Worry! The Timer Won't Reset",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black, //was grey at some point
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 16,
              ),
              child: Column(
                children: <Widget>[
                  ChangeRecoveryTimeWidget(
                    changeDuration: Duration(milliseconds: 250),
                    recoveryPeriod: possibleRecoveryDuration,
                  ),
                  Transform.translate(
                    offset: Offset(0, 16),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          RaisedButton(
                            color: Colors.blue,
                            onPressed: () {
                              changeableTimerDuration.value =
                                  possibleRecoveryDuration.value;
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Change",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Icon(
            Icons.edit,
            color: Colors.white,
            size: 56,
          ),
          color: Colors.black,
          isDense: true,
          animationType: AnimType.TOPSLIDE,
        );
      },
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
  _ChangeRecoveryTimeWidgetState createState() =>
      _ChangeRecoveryTimeWidgetState();
}

class _ChangeRecoveryTimeWidgetState extends State<ChangeRecoveryTimeWidget> {
  ValueNotifier<int> sectionID = new ValueNotifier(0);

  recoveryPeriodToSectionID() {
    if (widget.recoveryPeriod.value < Duration(seconds: 15))
      sectionID.value = 0; //nothing
    else {
      if (widget.recoveryPeriod.value <= Duration(minutes: 1))
        sectionID.value = 1; //endurance
      else {
        if (widget.recoveryPeriod.value <= Duration(minutes: 2))
          sectionID.value = 2; //hypertrophy
        else {
          if (widget.recoveryPeriod.value < Duration(minutes: 3))
            sectionID.value = 3; //hypertrophy/strength
          else
            sectionID.value = 4;
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
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Theme(
              data: MyTheme.dark,
              child: TrainingTypeSections(
                cardBackground: false,
                highlightField: 2,
                //nothing / endurance / hypertrohpy / hypertrophy & strength / strength and above
                sections: [
                  [0],
                  [0],
                  [1],
                  [1, 2],
                  [2]
                ],
                sectionID: sectionID,
              ),
            ),
          ),
          Theme(
            data: MyTheme.light,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 16.0,
                  bottom: 8,
                ),
                child: AnimRecoveryTimeInfoToWhiteTheme(
                  changeDuration: widget.changeDuration,
                  recoveryPeriod: widget.recoveryPeriod,
                  darkTheme: false,
                  hideNameButtons: true,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8.0,
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
