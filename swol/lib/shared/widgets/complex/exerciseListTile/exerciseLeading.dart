//flutter
import 'package:flutter/material.dart';

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
    @required this.transitionDuration,
    @required Key key,
  }) : super(key: key);

  final AnExercise exercise;
  final bool tileInSearch;
  final Duration transitionDuration;

  @override
  _ExerciseTileLeadingState createState() => _ExerciseTileLeadingState();
}

class _ExerciseTileLeadingState extends State<ExerciseTileLeading> {
  actualUpdate(){
    print(widget.exercise.id.toString() +" after wait: " + widget.exercise.tempStartTime.toString());
    if(mounted) setState(() {});
  }

  updateState(){
    print(widget.exercise.id.toString() +" before wait: " + widget.exercise.tempStartTime.toString());
    //NOTE: just waiting a single frame isn't enough
    Future.delayed(widget.transitionDuration, actualUpdate);
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

  //and also 
  @override
  Widget build(BuildContext context) {
    print(widget.exercise.id.toString() + " build: " + widget.exercise.tempStartTime.toString());

    //NOTE: timer takes precendence over regular inprogress
    if(widget.exercise.tempStartTime.value != AnExercise.nullDateTime){
      return AnimatedMiniNormalTimer(
        exercise: widget.exercise,
      );
    }
    else if(LastTimeStamp.isInProgress(widget.exercise.lastTimeStamp)){
      bool isLastSet = (widget.exercise.tempSetCount ?? 0) >= widget.exercise.setTarget;
      return Hero(
        tag: "exercise" + (isLastSet ? "Complete" : "Continue") + widget.exercise.id.toString(),
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
    }
    else{ //NOT in timer, NOT in progress => show in what section it is
      //since we are starting off the exercise we don't need to worry about suggesting an action
      //so we don't need to worry about anything being a hero
      if(widget.tileInSearch){
        if(LastTimeStamp.isNew(widget.exercise.lastTimeStamp)){
          return ListTileChipShell(
            chip: MyChip(
              chipString: 'NEW',
            ),
          );
        }
        else{
          if(LastTimeStamp.isHidden(widget.exercise.lastTimeStamp)){
            return ListTileChipShell(
              chip: MyChip(
                chipString: 'HIDDEN',
              ),
            );
          }
          else{
            return Text(
              DurationFormat.format(
                DateTime.now().difference(widget.exercise.lastTimeStamp),
                showMinutes: false,
                showSeconds: false,
                showMilliseconds: false,
                showMicroseconds: false,
                len: 0, //short
              ),
            );
          }
        }
      }
      else{
        return ExerciseBegin(
          inAppBar: false,
          exercise: widget.exercise,
        );
      }
    }
  }
}