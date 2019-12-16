//flutter
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:progress_indicators/progress_indicators.dart';

//internal structure
import 'package:swol/excercise/defaultDateTimes.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/other/durationFormat.dart';

//internal widgets
import 'package:swol/sharedWidgets/excerciseListTile/miniTimers/alienTimer.dart';
import 'package:swol/sharedWidgets/excerciseListTile/excerciseTile.dart';
import 'package:swol/sharedWidgets/excerciseListTile/miniTimers/normalTimer.dart';

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
      double width = 56;

      //in case at some point I want to switch between indicators
      Duration pusleDuration = Duration(milliseconds: 1000); //so its serves as a indicator of change as well
      List<Widget> pulsingBackgrounds = [
        //import 'package:flutter_spinkit/flutter_spinkit.dart';
        SpinKitDualRing(
          lineWidth: width/2,
          color: Colors.white,
          size: width,
          duration: pusleDuration,
        ),
        SpinKitDoubleBounce( //ABBY LIKED
          color: Colors.white,
          size: width,
          duration: pusleDuration,
        ),
        //import 'package:loading_indicator/loading_indicator.dart';
        LoadingIndicator(
          indicatorType: Indicator.ballScaleMultiple,
          color: Colors.white,
        ),
        LoadingIndicator(
          indicatorType: Indicator.ballScale, 
          color: Colors.white,
        ),
        //import 'package:progress_indicators/progress_indicators.dart';
        GlowingProgressIndicator( //KOBE LIKED
          child: Container(
            color: Colors.red.withOpacity(0.75),
          ),
          duration: Duration(milliseconds: 5000),
        ),
      ];

      double maxSize = 54;
    
      //62 is max size
      return Container(
        height: maxSize,
        width: maxSize,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Transform.translate(
                offset: Offset(0, 1.5),
                child: Container(
                  height: maxSize,
                  width: maxSize,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballScaleMultiple, 
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: new ClipPath(
                  clipper: new InvertedCircleClipper(),
                  child: Image(
                    image: new AssetImage("assets/alarm.gif"),
                    //lines being slightly distinguishable is ugly
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Icon(
                  FontAwesomeIcons.times,
                  color: Colors.red,
                )
              ),
            ),
          ],
        ),
      );
      //TODO: add the little animated alarm clock to this widget and then also change the timer to match the alarm clock
      //TODO: also start with a timer, then move onto a stopwatch (animate the little stick in)
      //TODO: the whole thing stays WHITE as long as the alarm clock isnt ringing
      /*AnimatedMiniNormalTimer(
        excerciseReference: excerciseReference,
      );*/
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
  @override
  Path getClip(Size size) {
    return new Path()
      ..addOval(new Rect.fromCircle(
          center: new Offset(size.width / 2, size.height / 2),
          radius: size.width * 0.25))
      ..addRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}