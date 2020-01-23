//flutter
import 'package:flutter/material.dart';

//internal: shared
import 'package:swol/shared/functions/defaultDateTimes.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//internal: other
import 'package:swol/excerciseListTile/miniTimer.dart';
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

class MyChip extends StatelessWidget {
  const MyChip({
    Key key,
    @required this.chipString,
    this.inverse: false,
  }) : super(key: key);

  final String chipString;
  final bool inverse;

  @override
  Widget build(BuildContext context) {
    Color chipColor = (inverse) ? Theme.of(context).primaryColorDark : Theme.of(context).accentColor;
    Color textColor = (inverse) ? Theme.of(context).accentColor : Theme.of(context).primaryColorDark;

    return Container(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
          right: 4,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 4,
          ),
          decoration: new BoxDecoration(
            color: chipColor,
            borderRadius: new BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: Text(
            chipString,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}