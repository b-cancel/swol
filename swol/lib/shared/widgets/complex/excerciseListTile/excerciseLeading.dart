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
    @required this.transitionDuration,
    @required Key key,
  }) : super(key: key);

  final AnExcercise excercise;
  final bool tileInSearch;
  final ValueNotifier<DateTime> dtTimerStarted;
  final Duration transitionDuration;

  @override
  _ExcerciseTileLeadingState createState() => _ExcerciseTileLeadingState();
}

class _ExcerciseTileLeadingState extends State<ExcerciseTileLeading> {
  //TODO: figure out wherethe random notifier identifiers are comming from
  //we start with: 74fe0
  //then change to: d515f AND 74fe0
  //then go back to: 74fe0
  //because we go back this whole thing works but it shouldn't change IDs in the first place
  /*
  before wait: ValueNotifier<DateTime>#74fe0(1969-12-31 18:00:00.000)
  I/flutter ( 1512): build: ValueNotifier<DateTime>#74fe0(1969-12-31 18:00:00.000)
  I/flutter ( 1512): build: ValueNotifier<DateTime>#d515f(1969-12-31 18:00:00.000)
  I/flutter ( 1512): after wait: ValueNotifier<DateTime>#74fe0(1969-12-31 18:00:00.000)
  I/flutter ( 1512): build: ValueNotifier<DateTime>#74fe0(1969-12-31 18:00:00.000)
  */
  actualUpdate(){
    print(widget.excercise.id.toString() +" after wait: " + widget.dtTimerStarted.toString());
    if(mounted) setState(() {});
  }

  updateState(){
    print(widget.excercise.id.toString() +" before wait: " + widget.dtTimerStarted.toString());
    //NOTE: just waiting a single frame isn't enough
    Future.delayed(widget.transitionDuration, actualUpdate);
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
    print(widget.excercise.id.toString() + " build: " + widget.dtTimerStarted.toString());

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