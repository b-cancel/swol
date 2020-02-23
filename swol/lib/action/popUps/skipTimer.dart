import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:swol/action/page.dart';
import 'package:swol/action/tabs/recovery/secondary/explained.dart';
import 'package:swol/other/durationFormat.dart';
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/widgets/complex/excerciseListTile/miniTimer/wrapper.dart';

maybeSkipTimer(
  BuildContext context, 
  AnExcercise excercise, 
  Function ifSkip, 
  Color headerColor,
) {
  //remove focus so the pop up doesnt bring it back
  FocusScope.of(context).unfocus();

  //are we way off? or are we atleast within the range for this type of workout
  String trainingSelected = durationToTrainingType(
    excercise.recoveryPeriod,
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
                  excercise: excercise,
                  dtTimerStarted: ExcercisePage.dtTimerStartedS.value,
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
              excercise: excercise,
              selectedWaitTime: DurationFormat.format(
                excercise.recoveryPeriod,
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
            Transform.translate(
              offset: Offset(0, 16),
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
                      "Don't Skip",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      //pop ourselves
                      Navigator.pop(context);

                      //proceed as expected
                      ifSkip();
                    },
                    child: Text(
                      "Skip Break",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        )
      ],
    ),
  ).show();
}

class UpdatingBreakSet extends StatelessWidget {
  UpdatingBreakSet({
    @required this.trainingName,
    @required this.selectedWaitTime,
    @required this.excercise,
  });

  final String trainingName;
  final String selectedWaitTime;
  final AnExcercise excercise;

  @override
  Widget build(BuildContext context) {
    Duration timePassed =  DateTime.now().difference(ExcercisePage.dtTimerStartedS.value);
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
