import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
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
        lastExerciseID: listOfGroupOfExercises.last.last.id,
      ),
    );
  }
}

class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  double semiClosedHeight;
  double closedHeight;
  double openHeight;
  int? lastExerciseID;

  PersistentHeaderDelegate({
    required this.semiClosedHeight,
    required this.closedHeight,
    required this.openHeight,
    this.lastExerciseID: 0,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    DateTime? lastTimeStamp = (lastExerciseID != null)
        ? ExerciseData.getExercises()[lastExerciseID]?.lastTimeStamp
        : null;

    //-----Used to clip the Exercises Title
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.all(0),
      //-----The Container that contracts and expands
      child: Container(
        height: openHeight,
        color: Theme.of(context).primaryColorDark,
        //-----What sets the max width of our text
        child: FractionallySizedBox(
          widthFactor: 0.65,
          //-----What lets the text overflow
          child: OverflowBox(
            minHeight: semiClosedHeight,
            maxHeight: double.infinity,
            //NOTE: if you set max height our text won't shrink
            //-----What grows the text as large as possible given the space
            child: FittedBox(
              fit: BoxFit.contain,
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

    //TODO: this stuff below
    //IF (the first largest thing) show all th way up to (acceptable smallest thing)
    //IF yr show all the way up to day
    //IF mth show all the way up to day
    //IF week show all the way up to day
    //IF day show all the way up to hour
    //IF hours show all the way up to minute
    //IF minutes show all thw way up to second

    return duration.toString();
  }

  //TODO: reload every 100ms

  @override
  Widget build(BuildContext context) {
    Duration timeSince = DateTime.now().difference(widget.lastTimeStamp);
    return Text(
      timeSince.toString() + "\n" + "since your last workout",
    );
  }
}
