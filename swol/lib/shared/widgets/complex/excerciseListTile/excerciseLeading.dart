//flutter
import 'package:flutter/material.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/excerciseListTile/miniTimer/wrapper.dart';
import 'package:swol/shared/widgets/simple/heros/curveMod.dart';
import 'package:swol/shared/widgets/simple/heros/leading.dart';
import 'package:swol/shared/functions/defaultDateTimes.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/widgets/simple/chip.dart';

//internal: other
import 'package:swol/other/durationFormat.dart';

//tile might need reloading
class ExcerciseTileLeading extends StatefulWidget {
  ExcerciseTileLeading({
    @required this.excercise,
    @required this.tileInSearch,
  });

  final AnExcercise excercise;
  final bool tileInSearch;

  @override
  _ExcerciseTileLeadingState createState() => _ExcerciseTileLeadingState();
}

class _ExcerciseTileLeadingState extends State<ExcerciseTileLeading> {
  //TODO listen to "lastTimeStamp", "tempStartTime"
  //TODO listen to "set target", "set count" to reload 
  //and also 
  @override
  Widget build(BuildContext context) {
    //NOTE: timer takes precendence over regular inprogress
    if(widget.excercise.tempStartTime != null){
      Duration timePassed = DateTime.now().difference(widget.excercise.tempStartTime);
      if(timePassed > Duration(minutes: 5)){
        return AnimatedMiniNormalTimerAlternativeWrapper(
          excerciseReference: widget.excercise,
        );
      }
      else{
        return AnimatedMiniNormalTimer(
          excerciseReference: widget.excercise,
        );
      }
    }
    else if(LastTimeStamp.isInProgress(widget.excercise.lastTimeStamp)){
      //TODO: this should show different things if you are BEFORE or PAST your set target
      //TODO: if before you set target it should show "To Set X/Y?"
      //TODO: if after your set target it should show "Complete Set X?"
      //TODO: both of these should be heros
      //TODO: and essentially show the user the button they need to press 
      //TODO: to perform the action we THINK they will want
      bool isLastSet = true;
      return Hero(
        tag: "excercise" + (isLastSet ? "Complete" : "Continue") + widget.excercise.id.toString(),
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
      //since we are starting off the excercise we don't need to worry about suggesting an action
      //so we don't need to worry about anything being a hero
      if(widget.tileInSearch){
        if(LastTimeStamp.isNew(widget.excercise.lastTimeStamp)){
          return ListTileChipShell(
            chip: MyChip(
              chipString: 'NEW',
            ),
          );
        }
        else{
          if(LastTimeStamp.isHidden(widget.excercise.lastTimeStamp)){
            return ListTileChipShell(
              chip: MyChip(
                chipString: 'HIDDEN',
              ),
            );
          }
          else{
            return Text(
              DurationFormat.format(
                DateTime.now().difference(widget.excercise.lastTimeStamp),
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
      else return ExcerciseBegin(
        inAppBar: false,
        excercise: widget.excercise,
      );
    }
  }
}