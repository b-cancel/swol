//flutter
import 'package:flutter/material.dart';
import 'package:swol/shared/widgets/complex/excerciseListTile/miniTimer.dart';

//internal: shared
import 'package:swol/shared/widgets/simple/heros/leading.dart';
import 'package:swol/shared/functions/defaultDateTimes.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/widgets/simple/chip.dart';

//internal: other
import 'package:swol/other/durationFormat.dart';

//tile might need reloading
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
      //TODO: this should show different things if you are BEFORE or PAST your set target
      //TODO: if before you set target it should show "To Set X/Y?"
      //TODO: if after your set target it should show "Complete Set X?"
      //TODO: both of these should be heros
      //TODO: and essentially show the user the button they need to press 
      //TODO: to perform the action we THINK they will want
      bool isLastSet = true;
      return Hero(
        tag: "excercise" + (isLastSet ? "Complete" : "Continue") + excerciseReference.id.toString(),
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
      else return ExcerciseBegin(
        inAppBar: false,
        excerciseIDTag: excerciseReference.id,
      );
    }
  }
}