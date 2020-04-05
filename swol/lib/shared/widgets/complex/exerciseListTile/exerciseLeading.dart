//flutter
import 'package:flutter/material.dart';
import 'package:swol/action/page.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/exerciseListTile/miniTimer/wrapper.dart';
import 'package:swol/shared/widgets/simple/heros/curveMod.dart';
import 'package:swol/shared/widgets/simple/heros/leading.dart';
import 'package:swol/shared/functions/defaultDateTimes.dart';
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/shared/widgets/simple/chip.dart';

//internal: other
import 'package:swol/other/durationFormat.dart';

//tile might need reloading
class ExerciseTileLeading extends StatefulWidget {
  ExerciseTileLeading({
    @required this.exercise,
    @required this.tileInSearch,
    @required Key key,
  }) : super(key: key);

  final AnExercise exercise;
  final bool tileInSearch;

  @override
  _ExerciseTileLeadingState createState() => _ExerciseTileLeadingState();
}

class _ExerciseTileLeadingState extends State<ExerciseTileLeading> {
  actualUpdate() {
    if (mounted) setState(() {});
  }

  updateState() {
    //NOTE: just waiting a single frame isn't enough
    //TODO: more fool proof solution because waiting one frame should be enough
    //if its isnt it may just the the unexpected delay that happens like everywhere
    //this REALLY SHOULD be enough, but fix if needed
    Future.delayed(ExercisePage.transitionDuration * 1.5, actualUpdate);
  }

  @override
  void initState() {
    //super init
    super.initState();

    //working listeners
    widget.exercise.tempStartTime.addListener(updateState);
  }

  @override
  void dispose() {
    //remove working listeners
    widget.exercise.tempStartTime.removeListener(updateState);

    //super dispose
    super.dispose();
  }

  grabFormattedDT(){
    String dt = DurationFormat.format(
      DateTime.now().difference(widget.exercise.lastTimeStamp),
      showMinutes: false,
      showSeconds: false,
      showMilliseconds: false,
      showMicroseconds: false,
      len: 0, //short
    );

    //remove thing if needed
    List units = dt.split(" ");

    //5 things must be there
    //so hours must be there
    if(units.length > 4){
      //years, months, weeks, days, hours
       String dt = DurationFormat.format(
        DateTime.now().difference(widget.exercise.lastTimeStamp),
        showHours: false,
        //---
        showMinutes: false,
        showSeconds: false,
        showMilliseconds: false,
        showMicroseconds: false,
        len: 0, //short
      );

      //update
      List units = dt.split(" ");
    }

    //add spacing where needed
    String result = "";
    for(int i = 0; i < units.length - 1; i++){
      result += units[i];
      result += (i%2 == 0) ? " " : "\n";
    }
    
    //return 
    return result + units.last;
  }

  //and also
  @override
  Widget build(BuildContext context) {
    //NOTE: timer takes precendence over regular inprogress
    if (widget.exercise.tempStartTime.value != AnExercise.nullDateTime) {
      return AnimatedMiniNormalTimer(
        exercise: widget.exercise,
      );
    } else {
      //what state is the exercise in
      TimeStampType timeStampType = LastTimeStamp.returnTimeStampType(
        widget.exercise.lastTimeStamp,
      );

      //different leadings based on timeStampType
      if (timeStampType == TimeStampType.InProgress) {
        bool isLastSet =
            (widget.exercise.tempSetCount ?? 0) >= widget.exercise.setTarget;
        return Hero(
          tag: "exercise" +
              (isLastSet ? "Complete" : "Continue") +
              widget.exercise.id.toString(),
          createRectTween: (begin, end) {
            return CustomRectTween(a: begin, b: end);
          },
          child: FittedBox(
            fit: BoxFit.contain,
            child: Material(
              color: Colors.transparent,
              child: ContinueOrComplete(
                afterLastSet: isLastSet,
              ),
            ),
          ),
        );
      } else {
        //NOT in timer, NOT in progress => show in what section it is
        //since we are starting off the exercise we don't need to worry about suggesting an action
        //so we don't need to worry about anything being a hero
        if (widget.tileInSearch) {
          if (timeStampType == TimeStampType.New) {
            return ListTileChipShell(
              chip: MyChip(
                chipString: 'NEW',
              ),
            );
          } else {
            if (timeStampType == TimeStampType.Hidden) {
              return ListTileChipShell(
                chip: MyChip(
                  chipString: 'HIDDEN',
                ),
              );
            } else {
              return FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  grabFormattedDT()
                ),
              );
            }
          }
        } else {
          return ExerciseBegin(
            inAppBar: false,
            exercise: widget.exercise,
          );
        }
      }
    }
  }
}
