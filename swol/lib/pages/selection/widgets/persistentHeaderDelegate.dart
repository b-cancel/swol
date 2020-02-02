import 'package:flutter/material.dart';
import 'package:swol/shared/structs/anExcercise.dart';

class HeaderForOneHandedUse extends StatelessWidget {
  const HeaderForOneHandedUse({
    Key key,
    @required this.listOfGroupOfExcercises,
    @required this.openHeight,
    @required this.newWorkoutSection,
    @required this.hiddenWorkoutSection,
    @required this.inprogressWorkoutSection,
  }) : super(key: key);

  final List<List<AnExcercise>> listOfGroupOfExcercises;
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
        workoutCount: listOfGroupOfExcercises.length 
        //exclude new workouts
        - (newWorkoutSection ? 1 : 0) 
        //exclude hidden workouts
        - (hiddenWorkoutSection ? 1 : 0)
        //exclude in progress since they either
        //- create a new section
        //- or replace a section
        - (inprogressWorkoutSection ? 1 : 0),
      ),
    );
  }
}

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
      subtitle = subtitle + " Workout";
      if(workoutCount > 1) subtitle += "s";
    }

    //-----Used to clip the Excercises Title
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.all(0),
      //-----The Container that contracts and expands
      child: Container(
        height: openHeight,
        /*
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1,0.5,0.95],
            colors: [
              Theme.of(context).accentColor,
              Colors.blue,
              Colors.black,
            ],
          ),
        ),
        */
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
                    style: TextStyle(
                      color: Colors.white,
                    ),
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