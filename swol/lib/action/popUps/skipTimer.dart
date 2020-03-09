//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:swol/action/popUps/button.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/exerciseListTile/miniTimer/wrapper.dart';
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/shared/methods/theme.dart';

//internal: shared
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
    zeroIsEndurance: false,
  );

  TextStyle bold = TextStyle(
    fontWeight: FontWeight.bold,
  );

  //show the dialog
  AwesomeDialog(
    context: context,
    isDense: false,
    //NOTE: on dimiss nothing except dismissing the dialog happens
    dismissOnTouchOutside: true,
    animType: AnimType.TOPSLIDE,
    customHeader: Theme(
      data: MyTheme.dark,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Container(
          height: 128,
          width: 128,
          decoration: BoxDecoration(
            color: headerColor,
            shape: BoxShape.circle,
          ),
          //NOTE: 28 is the max
          padding: EdgeInsets.all(0),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Transform.translate(
              offset: Offset(0, 2),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: AnimatedMiniNormalTimer(
                  exercise: exercise,
                  startTime: startTime,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    body: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            bottom: 16.0,
          ),
          child: Text(
            "Skip Break?",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ),
        /*
        In order to recovery fully from a Hypertrophy Training set
        you should wait between 2 and 3 minutes
        before moving on to your next set
        */
        //updating rich text
        ///"are you sure you want to Skip the rest of your break?"
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
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
    ),
    btnCancel: AwesomeButton(
      clear: true,
      child: Text(
        "Don't Skip",
      ),
      onTap: () {
        Navigator.pop(context);
      },
    ),
    btnOk: AwesomeButton(
      child: Text(
        "Skip Break",
      ),
      onTap: () {
        //pop ourselves
        Navigator.pop(context);

        //proceed as expected
        ifSkip();
      },
    ),
  ).show();
}

class UpdatingBreakSet extends StatelessWidget {
  UpdatingBreakSet({
    @required this.trainingName,
    @required this.selectedWaitTime,
    @required this.exercise,
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
      zeroIsEndurance: false,
    );

    bool withinTrainingType = (trainingName == trainingBreakGoodFor);
    TextStyle bold = TextStyle(
      fontWeight: FontWeight.bold,
    );

    String timeWaited = DurationFormat.format(
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

    if (withinTrainingType) {
      return RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
          ),
          children: [
            TextSpan(text: "So far you have waited "),
            TextSpan(
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
              text: selectedWaitTime,
              style: bold,
            ),
          ],
        ),
      );
    } else {
      return RichText(
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
