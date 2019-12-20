//flutter
import 'package:flutter/material.dart';

//internal structure
import 'package:swol/excercise/defaultDateTimes.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/other/durationFormat.dart';

//internal widgets
import 'package:swol/sharedWidgets/excerciseListTile/excerciseTile.dart';
import 'package:swol/sharedWidgets/excerciseListTile/miniTimers/normalTimer.dart';

//tile might need reloading
class ExcerciseTileLeading extends StatelessWidget {
  ExcerciseTileLeading({
    @required this.excerciseReference,
    @required this.tileInSearch,
  });

  final AnExcercise excerciseReference;
  final bool tileInSearch;

  //reusable function
  static double timeToLerpValue(Duration timePassed){
    return timePassed.inMicroseconds / Duration(minutes: 5).inMicroseconds;
  }

  @override
  Widget build(BuildContext context) {
    //NOTE: timer takes precendence over regular inprogress
    if(excerciseReference.tempStartTime != null){
      Duration timePassed = DateTime.now().difference(excerciseReference.tempStartTime);
      if(timePassed > Duration(minutes: 5)){
        return AnimatedMiniNormalTimerAlternativeWrapper(
          excerciseReference: excerciseReference,
        );
      }
      else{
        return AnimatedMiniNormalTimer(
          excerciseReference: excerciseReference,
        );
      }
    }
    else if(LastTimeStamp.isInProgress(excerciseReference.lastTimeStamp)){
      return Container(
        child: Text("Finished?"),
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

//from: https://stackoverflow.com/questions/49374893/flutter-inverted-clipoval/49396544
class InvertedCircleClipper extends CustomClipper<Path> {
  InvertedCircleClipper({
    this.radiusPercent: 0.25,
  });

  final double radiusPercent;

  @override
  Path getClip(Size size) {
    return new Path()
      ..addOval(new Rect.fromCircle(
          center: new Offset(size.width / 2, size.height / 2),
          radius: size.width * radiusPercent))
      ..addRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}