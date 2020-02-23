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
    @required this.dtTimerStarted,
  });

  final AnExcercise excercise;
  final bool tileInSearch;
  final ValueNotifier<DateTime> dtTimerStarted;

  @override
  _ExcerciseTileLeadingState createState() => _ExcerciseTileLeadingState();
}

class _ExcerciseTileLeadingState extends State<ExcerciseTileLeading> {
  actualUpdate(Duration randomDuration){
    if(mounted) setState(() {});
  }

  updateState(){
    //wait one frame for things to update
    WidgetsBinding.instance.addPostFrameCallback(actualUpdate);
  }

  @override
  void initState() {
    //super init
    super.initState();

    //working listeners
    widget.dtTimerStarted.addListener(updateState);
  }

  @override
  void dispose() { 
    //remove working listeners
    widget.dtTimerStarted.removeListener(updateState);

    //super dispose
    super.dispose();
  }

  //and also 
  @override
  Widget build(BuildContext context) {
    //NOTE: timer takes precendence over regular inprogress
    if(widget.dtTimerStarted.value != AnExcercise.nullDateTime){
      return AnimatedMiniNormalTimer(
        excercise: widget.excercise,
        dtTimerStarted: widget.dtTimerStarted.value,
      );
    }
    else if(LastTimeStamp.isInProgress(widget.excercise.lastTimeStamp)){
      bool isLastSet = (widget.excercise.tempSetCount ?? 0) >= widget.excercise.setTarget;
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
                len: 0, //short
              ),
            );
          }
        }
      }
      else{
        return ExcerciseBegin(
          inAppBar: false,
          excercise: widget.excercise,
        );
      }
    }
  }
}