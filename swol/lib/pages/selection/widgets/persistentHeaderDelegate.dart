import 'package:flutter/material.dart';
import 'package:swol/shared/functions/defaultDateTimes.dart';
import 'package:swol/shared/methods/exerciseData.dart';
import 'package:swol/shared/structs/anExercise.dart';

class HeaderForOneHandedUse extends StatelessWidget {
  const HeaderForOneHandedUse({
    Key? key,
    required this.listOfGroupOfExercises,
    required this.openHeight,
    required this.newWorkoutSection,
    required this.hiddenWorkoutSection,
    required this.inprogressWorkoutSection,
  }) : super(key: key);

  final List<List<AnExercise>> listOfGroupOfExercises;
  final double openHeight;
  final bool newWorkoutSection;
  final bool hiddenWorkoutSection;
  final bool inprogressWorkoutSection;

  bool isGroupOther(List<AnExercise> group) {
    AnExercise mostRecent = group.last;
    TimeStampType timeStampType = LastTimeStamp.returnTimeStampType(
      mostRecent.lastTimeStamp,
    );
    return timeStampType == TimeStampType.Other;
  }

  //ATLEAST one group is available
  DateTime? getMostRecentOtherDateTime() {
    if (isGroupOther(listOfGroupOfExercises.last)) {
      return listOfGroupOfExercises.last.last.lastTimeStamp;
    } else {
      //not the last one which we already checked above
      if (listOfGroupOfExercises.length > 1) {
        List<AnExercise> groupBeforeTheLast =
            listOfGroupOfExercises[listOfGroupOfExercises.length - 2];
        if (isGroupOther(groupBeforeTheLast)) {
          return groupBeforeTheLast.last.lastTimeStamp;
        }
      }
    }
  }

  DateTime? getMostRecentInProgressDateTime() {
    List<AnExercise> maybeInProgressGroup = listOfGroupOfExercises[0];
    //the in progress group if it exists is allways on top
    if (maybeInProgressGroup.length > 0) {
      //most recent is on the bottom for this group
      AnExercise mostRecent = maybeInProgressGroup[0];
      //use the last time stamp ONLY for determining the type
      TimeStampType mostRecentTimeStampType =
          LastTimeStamp.returnTimeStampType(mostRecent.lastTimeStamp);
      //if its the type we are looking for then grab our actual temp start time
      if (mostRecentTimeStampType == TimeStampType.InProgress) {
        return mostRecent.tempStartTime.value;
      }
    }
  }

  //if an in progress section exists
  // -> use the one with the date time closest to the present
  //otherwise if any other sections exists
  // -> use the last last exercise
  DateTime? getMostRecentExerciseTimestamp() {
    //in progress (0 or 1)
    //new (0 or 1) [no usable time]
    //other (0 or many) [only last of last is relevant]
    //hide (0 or 1) [no usable time]
    if (listOfGroupOfExercises.length > 0) {
      //there are groups
      //check if the last group has anything in it
      DateTime? mostRecentInProgressTimeStamp =
          getMostRecentInProgressDateTime();
      DateTime? mostRecentOtherTimeStamp = getMostRecentOtherDateTime();

      //they are both not null
      if (mostRecentInProgressTimeStamp != null &&
          mostRecentOtherTimeStamp != null) {
        //choose whatever timestamp is closer to us
        DateTime now = DateTime.now();
        Duration nowToInProgress =
            now.difference(mostRecentInProgressTimeStamp);
        Duration nowToOther = now.difference(mostRecentOtherTimeStamp);

        //pick the one with the smallest difference
        if (nowToInProgress < nowToOther) {
          return mostRecentInProgressTimeStamp;
        } else {
          return mostRecentOtherTimeStamp;
        }
      } else {
        if (mostRecentInProgressTimeStamp != null) {
          return mostRecentInProgressTimeStamp;
        } else if (mostRecentOtherTimeStamp != null) {
          return mostRecentOtherTimeStamp;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime? lastValidDateTime = getMostRecentExerciseTimestamp();
    return SliverPersistentHeader(
      pinned: false,
      floating: false,
      delegate: PersistentHeaderDelegate(
        semiClosedHeight: 60,
        //we get the smallest of the 2 golden ratio stuff produced
        //and then we subtract the status bar height
        //since it SEEMS like it belong to the top thingy and therefore should be excluded
        openHeight: openHeight,
        closedHeight: 0,
        lastValidDateTime: lastValidDateTime,
      ),
    );
  }
}

class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  double semiClosedHeight;
  double closedHeight;
  double openHeight;
  DateTime? lastValidDateTime;

  PersistentHeaderDelegate({
    required this.semiClosedHeight,
    required this.closedHeight,
    required this.openHeight,
    this.lastValidDateTime,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    DateTime? lastTimeStamp =
        (lastValidDateTime != null) ? lastValidDateTime : null;

    //-----Used to clip the Exercises Title
    return Container(
      height: openHeight,
      color: Theme.of(context).primaryColorDark,
      //-----What sets the max width of our text
      child: Center(
        child: FractionallySizedBox(
          widthFactor: 0.65,
          //-----What lets the text overflow
          child: OverflowBox(
            minHeight: semiClosedHeight,
            maxHeight: double.infinity,
            //NOTE: if you set max height our text won't shrink
            //-----What grows the text as large as possible given the space
            child: FittedBox(
              fit: BoxFit.scaleDown,
              //-----A Little PaddingSpecifically for when its close to closed
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 2,
                ),
                child: lastTimeStamp != null
                    ? TimeSince(lastTimeStamp: lastTimeStamp)
                    : RichText(
                        textScaleFactor: MediaQuery.of(
                          context,
                        ).textScaleFactor,
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 48,
                          ),
                          text: "Begin Your Journey",
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => openHeight;

  @override
  double get minExtent => closedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class TimeSince extends StatefulWidget {
  const TimeSince({
    required this.lastTimeStamp,
    Key? key,
  }) : super(key: key);

  final DateTime lastTimeStamp;

  @override
  _TimeSinceState createState() => _TimeSinceState();
}

class _TimeSinceState extends State<TimeSince> {
  String unitsToString(
    List<int> units,
    List<String> unitLabels,
    int start,
    int end,
  ) {
    bool showEvenIfZero = (end - start) == 1;
    String output = "";
    for (int i = start; i <= end; i++) {
      int val = units[i];
      if (val != 0 || (val == 0 && showEvenIfZero)) {
        String value =
            val.toString() + " " + unitLabels[i] + (val != 1 ? "s" : "");

        //something else is ahead, add a space
        if (output.length != 0) {
          output += " ";
        }
        output += value;
      }
    }
    return output;
  }

  String durationToText(Duration duration) {
    int years = duration.inDays ~/ 365;
    //total days... minus the days from years
    int months = (duration.inDays - (years * 365)) ~/ 30;
    //total days... minus the days from years... minus the days from months
    int weeks = (duration.inDays - (years * 365) - (months * 30)) ~/ 7;
    //total days... minus the days from years... minus the days from months... minus the days from weeks
    int days = (duration.inDays - (years * 365) - (months * 30) - (weeks * 7));

    //we already handled days above
    int hours = duration.inHours % 24;
    //we already handled hours above
    int minutes = duration.inMinutes % 60;
    //we already handled minutes above
    int seconds = duration.inSeconds % 60;

    //units
    List<int> units = [years, months, weeks, days, hours, minutes, seconds];
    List<String> unitLabels = ["yr", "mth", "wk", "day", "hr", "min", "sec"];

    //IF (the first largest thing) show all th way up to (acceptable smallest thing)
    if (years > 0) {
      //IF yr show all the way up to day
      return unitsToString(units, unitLabels, 0, 3);
    } else {
      if (months > 0) {
        //IF mth show all the way up to day
        return unitsToString(units, unitLabels, 1, 3);
      } else {
        if (weeks > 0) {
          //IF week show all the way up to day
          return unitsToString(units, unitLabels, 2, 3);
        } else {
          if (days > 0) {
            //IF day show all the way up to hour
            return unitsToString(units, unitLabels, 3, 4);
          } else {
            if (hours > 0) {
              //IF hours show all the way up to minute
              return unitsToString(units, unitLabels, 4, 5);
            } else {
              //IF minutes show all thw way up to second
              return unitsToString(units, unitLabels, 5, 6);
            }
          }
        }
      }
    }
  }

  waitThenReload() async {
    //wait a bit
    await Future.delayed(
      Duration(milliseconds: 100),
    );
    //reload
    if (mounted) {
      setState(() {});
      //loop
      waitThenReload();
    }
  }

  @override
  void initState() {
    super.initState();
    waitThenReload();
  }

  @override
  Widget build(BuildContext context) {
    Duration timeSince = DateTime.now().difference(widget.lastTimeStamp);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          durationToText(timeSince),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        Text(
          "since your last completed set",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
