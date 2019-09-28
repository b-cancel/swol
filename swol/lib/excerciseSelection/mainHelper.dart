import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/utils/theme.dart';

class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  double semiClosedHeight;
  double closedHeight;
  double openHeight;
  int workoutCount;

  PersistentHeaderDelegate({
    @required this.semiClosedHeight,
    @required this.closedHeight,
    @required this.openHeight,
    this.workoutCount: 0,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent){
    String subtitle = "";
    if(workoutCount != null && workoutCount > 0){
      subtitle = workoutCount.toString();
      subtitle = subtitle + " Workouts";
    }

    //-----Used to clip the Excercises Title
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
                //-----Our Text
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Exercises\n",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                        ),
                      ),
                      TextSpan(
                        text: subtitle,
                        style: TextStyle(
                          fontSize: 16,
                        )
                      ),
                    ],
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

List<String> indexToChar = [
  "y","m","w","d","h","m","s","milli","micro"
];

List<String> indexToString = [
  "year", "month", "week", "day", "hour", 
  "minute", "second", "millisecond", "microsecond",
];

String formatDuration(Duration timeSince, {
  bool showYears: true, //365 days
  bool showMonths: true, //30 days
  bool showWeeks: true, //7 days
  bool showDays: true, //24 hrs
  bool showHours: true, //60 minutes
  bool showMinutes: true, //60 seconds
  //TODO: left true for testing later
  bool showSeconds: true, //1000 milliseconds
  bool showMilliseconds: false,
  bool showMicroseconds: false,
  //long or short?
  bool short: true,
}){
  if(timeSince > Duration.zero){
    //setup vars
    int years = 0;
    int months = 0;
    int weeks = 0;
    int days = 0;
    int hours = 0;
    int minutes = 0;
    int seconds = 0;
    int milliseconds = 0;
    int microseconds = 0;

    //digest it given the variables
    if(showYears && timeSince.inDays > 0){
      years = timeSince.inDays ~/ 365;
      timeSince = timeSince - Duration(days: (365 * years));
    }

    if(showMonths && timeSince.inDays > 0){
      months = timeSince.inDays ~/ 30;
      timeSince = timeSince - Duration(days: (30 * months));
    }

    if(showWeeks && timeSince.inDays > 0){
      weeks = timeSince.inDays ~/ 7;
      timeSince = timeSince - Duration(days: (7 * weeks));
    }

    if(showDays && timeSince.inDays > 0){
      days = timeSince.inDays;
      timeSince = timeSince - Duration(days: days);
    }

    if(showHours && timeSince.inHours > 0){
      hours = timeSince.inHours;
      timeSince = timeSince - Duration(hours: hours);
    }

    if(showMinutes && timeSince.inMinutes > 0){
      minutes = timeSince.inMinutes;
      timeSince = timeSince - Duration(minutes: minutes);
    }

    if(showSeconds && timeSince.inSeconds > 0){
      seconds = timeSince.inSeconds;
      timeSince = timeSince - Duration(seconds: seconds);
    }

    if(showMilliseconds && timeSince.inMilliseconds > 0){
      milliseconds = timeSince.inMilliseconds;
      timeSince = timeSince - Duration(milliseconds: milliseconds);
    }

    if(showMilliseconds && timeSince.inMicroseconds > 0){
      microseconds = timeSince.inMicroseconds;
    }

    //create string
    String output = "";
    List<int> times = [
      years, 
      months, 
      weeks, 
      days, 
      hours, 
      minutes, 
      seconds, 
      milliseconds, 
      microseconds,
    ];
    
    //loop through and generate
    for(int i = 0; i < times.length; i++){
      int value = times[i];
      if(value != 0){
        String description = (short) ? indexToChar[i] : indexToString[i];
        if(short) description = indexToChar[i];
        else{
          description = indexToString[i];
          description = (value > 1) ? description + "s" : description;
          description = " " + description;
        }

        output += (times[i].toString() + description + " ");
      }
    }

    //return stuffs
    if(output == "") return "Today";
    else return output;
  }
  else return "Archived";
}

Map<int,String> weekDayToString = {
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
  6: "Saturday",
  7: "Sunday",
};