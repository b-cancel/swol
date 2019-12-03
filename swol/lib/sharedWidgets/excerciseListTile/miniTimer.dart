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
      return AnimatedMiniTimer(
        excerciseReference: excerciseReference,
        evenSliceDivision: true, 
        negativeFirst: true,
      );
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
    this.flipUnEveness: false,
    this.negativeFirst: true,
  });

  final AnExcercise excerciseReference;
  final bool evenSliceDivision;
  final bool flipUnEveness;
  final bool negativeFirst;
  //entire slice---
  //360/5 = 72

  //even---
  //72/2 = 36

  //uneven---
  //72/4 = 18
  //  * 3 = 54

  int by36(int i){
    return 36 * i;
  }

  @override
  Widget build(BuildContext context) {
    //generate all start angles of slices
    List<int> angles = new List<int>();
    
    //generate all angles
    if(evenSliceDivision){
      for(int i = 0; i < 10 ; i++) angles.add(by36(i));
    }
    else{
      for(int i = 0; i < 5; i++){
        int first = flipUnEveness ? 1 : 3;
        angles.add(by36(i*2)); 
        angles.add(by36(i*2) + (18 * first));
      }
    }

    //in all cases you are going to end in 360
    //you may or may not need this
    //plan for it below
    angles.add(360);

    //generate slices
    
    List<Widget> slices = new List<Widget>();
    //-1 is for the 360
    for(int i = 0; i < angles.length-1; i++){ 
      bool isEven = (i%2 == 0);
      bool useStartAngle = false;
      if(isEven && negativeFirst == false) useStartAngle = true;
      else if(isEven == false && negativeFirst) useStartAngle = true;
      if(useStartAngle){
        slices.add(
          TriangleAngle(
            start: angles[i].toDouble(),
            end: angles[i + 1].toDouble(),
          )
        );
      }
    }

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