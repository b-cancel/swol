//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/exerciseListTile/miniTimer/wrapper.dart';
import 'package:swol/shared/widgets/simple/ourHeaderIconPopUp.dart';
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/shared/methods/theme.dart';

//internal: other
import 'package:swol/action/tabs/recovery/secondary/explained.dart';
import 'package:swol/other/durationFormat.dart';

//function
maybeSkipTimer(
  BuildContext context,
  AnExercise exercise,
  Function ifSkip,
  Color headerColor,
  DateTime startTime,
) {
  //are we way off? or are we atleast within the range for this type of workout
  String trainingSelected = durationToTrainingType(
    exercise.recoveryPeriod,
  );

  //they select a break too short for it to matter
  //if they skip their break
  //also helps us avoid the edge case of durationToTrainingType
  if (trainingSelected.length <= 0) {
    ifSkip();
  } else {
    TextStyle bold = TextStyle(
      fontWeight: FontWeight.bold,
    );

    //show the dialog
    showCustomHeaderIconPopUp(
      context,
      [
        Text(
          "Skip Break?",
          style: TextStyle(
            fontSize: 28,
          ),
        ),
      ],
      [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                textScaleFactor: MediaQuery.of(
                  context,
                ).textScaleFactor,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "In order to recover fully from ",
                    ),
                    TextSpan(
                      style: bold,
                      text: trainingSelected + " Training",
                    ),
                    TextSpan(text: " you should wait between "),
                    TextSpan(
                      style: bold,
                      text: trainingTypeToMin(trainingSelected),
                    ),
                    TextSpan(text: " and "),
                    TextSpan(
                      style: bold,
                      text: trainingTypeToMax(trainingSelected),
                    ),
                    TextSpan(text: " before moving on to your next set\n"),
                  ],
                ),
              ),
              UpdatingBreakSet(
                trainingName: trainingSelected,
                exercise: exercise,
                //guarnateed to be larger than 15 second period
                selectedWaitTime: DurationFormat.format(
                  exercise.recoveryPeriod,
                  //no longer
                  showYears: false,
                  showMonths: false,
                  showWeeks: false,
                  showDays: false,
                  showHours: false,
                  //yes medium
                  showMinutes: true,
                  showSeconds: true,
                  //no tiny
                  showMilliseconds: false,
                  showMicroseconds: false,
                  //option
                  len: 2, //long
                  spaceBetween: true,
                ),
              ),
              RichText(
                textScaleFactor: MediaQuery.of(
                  context,
                ).textScaleFactor,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "\nAre you sure you want to ",
                    ),
                    TextSpan(
                      text: "Skip the rest of your break?",
                      style: bold,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      Transform.translate(
        offset: Offset(0, 4),
        child: Theme(
          data: MyTheme.dark,
          child: AnimatedMiniNormalTimer(
            exercise: exercise,
            startTime: startTime,
          ),
        ),
      ),
      headerBackground: headerColor,
      regularPadding: false,
      isDense: false,
      animationType: AnimType.TOPSLIDE,
      clearBtn: TextButton(
        child: Text(
          "Don't Skip",
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      colorBtn: ElevatedButton(
        child: Text(
          "Skip Break",
        ),
        onPressed: () {
          //pop ourselves
          Navigator.pop(context);

          //proceed as expected
          ifSkip();
        },
      ),
    );
  }
}

class UpdatingBreakSet extends StatelessWidget {
  UpdatingBreakSet({
    required this.trainingName,
    required this.selectedWaitTime,
    required this.exercise,
  });

  final String trainingName;
  final String selectedWaitTime;
  final AnExercise exercise;

  @override
  Widget build(BuildContext context) {
    Duration timePassed =
        DateTime.now().difference(exercise.tempStartTime.value);
    String trainingBreakGoodFor = durationToTrainingType(
      timePassed,
    );

    bool withinTrainingType = (trainingName == trainingBreakGoodFor);
    TextStyle bold = TextStyle(
      fontWeight: FontWeight.bold,
    );

    String timeWaited;
    if (timePassed.inSeconds > 0) {
      timeWaited = DurationFormat.format(
        timePassed,
        //no longer
        showYears: false,
        showMonths: false,
        showWeeks: false,
        showDays: false,
        showHours: false,
        //yes medium
        showMinutes: true,
        showSeconds: true,
        //no tiny
        showMilliseconds: false,
        showMicroseconds: false,
        //option
        len: 2, //long
        spaceBetween: true,
      );
    } else {
      timeWaited = "0 seconds";
    }

    if (withinTrainingType) {
      return RichText(
        textScaleFactor: MediaQuery.of(
          context,
        ).textScaleFactor,
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: "So far you have waited ",
            ),
            TextSpan(
              //handles 0 seconds case
              text: timeWaited,
              style: bold,
            ),
            TextSpan(
              text: ", so you are ready for your next ",
            ),
            TextSpan(
              text: trainingName + " Training",
              style: bold,
            ),
            TextSpan(
              text: " set\n\n",
            ),
            TextSpan(
              text: "But you have chosen to wait ",
            ),
            TextSpan(
              //atleast 15 seconds
              text: selectedWaitTime,
              style: bold,
            ),
          ],
        ),
      );
    } else {
      return RichText(
        textScaleFactor: MediaQuery.of(
          context,
        ).textScaleFactor,
        textAlign: TextAlign.left,
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: "but so far you have only waited ",
            ),
            TextSpan(
              text: timeWaited,
              style: bold,
            ),
          ],
        ),
      );
    }
  }
}
