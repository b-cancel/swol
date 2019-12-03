import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/excercise/defaultDateTimes.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/other/durationFormat.dart';
import 'package:swol/sharedWidgets/excerciseListTile/excerciseTile.dart';
import 'package:swol/sharedWidgets/excerciseListTile/triangleAngle.dart';

class ExcerciseTileLeading extends StatelessWidget {
  ExcerciseTileLeading({
    @required this.excerciseReference,
    @required this.tileInSearch,
  });

  final AnExcercise excerciseReference;
  final bool tileInSearch;

  @override
  Widget build(BuildContext context) {
    //NOTE: timer takes precendence over regular inprogress
    if(excerciseReference.tempStartTime != null){
      return AnimatedMiniTimer(excerciseReference: excerciseReference);
    }
    else if(LastTimeStamp.isInProgress(excerciseReference.lastTimeStamp)){
      return Container(
        child: Text("Finished"),
      );
    }
    else{ //NOT in timer, NOT in progress => show in what section it is
      if(tileInSearch){
        if(LastTimeStamp.isNew(excerciseReference.lastTimeStamp)){
          return ListTileChipShell(
            chip: MyChip(
              chipString: 'NEW',
            ),
          );
        }
        else{
          if(LastTimeStamp.isHidden(excerciseReference.lastTimeStamp)){
            return ListTileChipShell(
              chip: MyChip(
                chipString: 'HIDDEN',
              ),
            );
          }
          else{
            return Text(
              DurationFormat.format(
                DateTime.now().difference(excerciseReference.lastTimeStamp),
                showMinutes: false,
                showSeconds: false,
                showMilliseconds: false,
                showMicroseconds: false,
                short: true,
              ),
            );
          }
        }
      }
      else return Icon(Icons.chevron_right);
    }
  }
}

class ListTileChipShell extends StatelessWidget {
  const ListTileChipShell({
    Key key,
    @required this.chip,
  }) : super(key: key);

  final Widget chip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          chip,
        ],
      ),
    );
  }
}

class AnimatedMiniTimer extends StatelessWidget {
  AnimatedMiniTimer({
    @required this.excerciseReference,
    this.evenSliceDivision: true,
    this.negativeFirst: true,
  });

  final AnExcercise excerciseReference;
  final bool evenSliceDivision;
  final bool negativeFirst;

  @override
  Widget build(BuildContext context) {
    
    double pieSlice = 360/5;
    double negativeMultiplier = (evenSliceDivision) ? .5 : .25;
    double positiveMultiplier = (evenSliceDivision) ? .5 : .75;

    //generate slices
    List<Widget> slices = new List<Widget>();
    for(int i = 0; i < 5; i++){ //always only 5 slices
    /*
      slices.add(
        TriangleAngle(

        )
      );
      */
    }

    //TODO: remove when slices are functional
    slices.add(
      Container(
        color: Colors.pink,
      )
    );

    //display slices
    double size = 56; //NOTE: largest possible size seems to be 62
    return Container(
      width: size,
      height: size,
      color: Colors.pink,
      child: Stack(
        children: slices,
      )
    );
  }
}