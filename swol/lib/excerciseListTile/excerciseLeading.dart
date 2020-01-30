//flutter
import 'package:flutter/material.dart';
import 'package:swol/excerciseListTile/titleHero.dart';

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
      //TODO: both of these should hero with the actual timer
      //TODO: whatever that ends up being
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

class ContinueOrComplete extends StatelessWidget {
  const ContinueOrComplete({
    @required this.afterLastSet,
    Key key,
  }) : super(key: key);

  final bool afterLastSet;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).accentColor,
      ),
      padding: EdgeInsets.all(8),
      child: Text(
        afterLastSet ? "Finished?" : "Next Set?",
        style: TextStyle(
          color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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