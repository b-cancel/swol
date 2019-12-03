import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/other/durationFormat.dart';

/*
class ExcerciseTileLeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //if in progress set the proper icon
    if(LastTimeStamp.isInProgress(thisExcercise.lastTimeStamp)){
      if(thisExcercise.tempStartTime != null){
        //TODO test below
        Duration timeSinceBreakStarted = DateTime.now().difference(thisExcercise.tempStartTime);
        if(timeSinceBreakStarted > thisExcercise.recoveryPeriod){
          trailing = Icon(
            FontAwesomeIcons.hourglassEnd, //time done ticking
            color: Colors.red,
          );
        }
        else trailing = Icon(FontAwesomeIcons.hourglassHalf); //time ticking
      }
      else trailing = Icon(FontAwesomeIcons.hourglassStart); //time may tick again
    }
    else{
      if(tileInSearch){
        if(LastTimeStamp.isNew(thisExcercise.lastTimeStamp)){
          trailing = ListTileChipShell(
            chip: MyChip(
              chipString: 'NEW',
            ),
          );
        }
        else{
          if(LastTimeStamp.isHidden(thisExcercise.lastTimeStamp)){
            trailing = ListTileChipShell(
              chip: MyChip(
                chipString: 'HIDDEN',
              ),
            );
          }
          else{
            trailing = Text(
              DurationFormat.format(
                DateTime.now().difference(thisExcercise.lastTimeStamp),
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
      else trailing = Icon(Icons.chevron_right);
    }
  }
}
*/