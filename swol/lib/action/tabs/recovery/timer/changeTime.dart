//flutter
import 'package:flutter/material.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/trainingTypeTables/trainingTypes.dart';
import 'package:swol/shared/widgets/complex/RecoveryTime/minSecs.dart';
import 'package:swol/shared/widgets/complex/recoveryTime/picker.dart';
import 'package:swol/shared/widgets/simple/ourHeaderIconPopUp.dart';
import 'package:swol/shared/methods/theme.dart';

//internal: other
import 'package:swol/pages/add/widgets/recoveryTime.dart';

//function
class ActualButton extends StatelessWidget {
  const ActualButton({
    Key? key,
    required this.color,
    required this.changeableTimerDuration,
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
        showCustomHeaderIconPopUp(
          context,
          [
            Text(
              "Change Break Time",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            Text(
              "Don't Worry! The Timer Won't Reset",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
          [
            ChangeRecoveryTimeWidget(
              recoveryPeriod: possibleRecoveryDuration,
            ),
          ],
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          headerBackground: Colors.black,
          isDense: true,
          clearBtn: TextButton(
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          colorBtn: ElevatedButton(
            child: Text(
              "Change",
            ),
            onPressed: () {
              changeableTimerDuration.value = possibleRecoveryDuration.value;
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}

//the main beef and content that switches or slides between the different options as the user edits the setting
class ChangeRecoveryTimeWidget extends StatefulWidget {
  ChangeRecoveryTimeWidget({
    Key? key,
    required this.recoveryPeriod,
  }) : super(key: key);

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
                MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 1.0,
                  ),
                  child: RecoveryTimePicker(
                    duration: widget.recoveryPeriod,
                    darkTheme: false,
                  ),
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
