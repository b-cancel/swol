import 'package:flutter/material.dart';

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