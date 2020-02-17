//flutter
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:swol/action/page.dart';
import 'package:swol/action/shared/setToolTips.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//plugin
import 'package:vector_math/vector_math_64.dart' as vect;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//internal
import 'package:swol/shared/functions/goldenRatio.dart';

//widget
class SetDisplay extends StatefulWidget {
  const SetDisplay({
    Key key,
    //if its passed then use LAST
    //else use locals updated by stuff all over
    this.excercise,
    //other
    @required this.title,
    this.extraCurvy: false,
    @required this.useAccent,
    //optional
    this.heroUp,
    this.heroAnimDuration,
    this.heroAnimTravel,
  }) : super(key: key);

  final AnExcercise excercise;
  //other
  final String title;
  final bool extraCurvy;
  final bool useAccent;
  //optional
  final ValueNotifier<bool> heroUp;
  final Duration heroAnimDuration;
  final double heroAnimTravel;

  @override
  _SetDisplayState createState() => _SetDisplayState();
}

class _SetDisplayState extends State<SetDisplay> {
  updateState(){
    if(mounted) setState(() {});
  }

  @override
  void initState() {
    if(widget.heroUp != null){
      widget.heroUp.addListener(updateState);
    }
    super.initState();
  }

  @override
  void dispose() { 
    if(widget.heroUp != null){
      widget.heroUp.removeListener(updateState);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<double> defGW = measurementToGoldenRatioBS(250);
    double curveValue = widget.extraCurvy ? 48 : 24;
    double difference = 12;

    Color backgroundColor = widget.useAccent ? Theme.of(context).accentColor : Theme.of(context).cardColor;
    if(widget.heroUp != null){
      backgroundColor = widget.heroUp.value ? Theme.of(context).accentColor : Theme.of(context).cardColor;
    }

    Color foregroundColor = widget.useAccent ? Theme.of(context).primaryColorDark : Colors.white;
    if(widget.heroUp != null){
      foregroundColor = widget.heroUp.value ? Theme.of(context).primaryColorDark : Colors.white;
    }

    double movementY = 0;
    if(widget.heroUp != null){
      if(widget.useAccent) movementY = widget.heroUp.value ? 0 : widget.heroAnimTravel;
      else movementY = widget.heroUp.value ? -widget.heroAnimTravel : 0;
    }

    //widget
    return AnimatedContainer(
      duration: widget.heroAnimDuration ?? Duration.zero,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(curveValue)),
      ),
      //NOTE: I can't change alignment since that will mess up the FittedBox child
      transform:  Matrix4.translation(
        vect.Vector3(
          0, 
          movementY,
          0,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: curveValue - difference,
        vertical: difference,
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Container(
          width: 250,
          height: 28,
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 24,
              color: foregroundColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: defGW[1],
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: foregroundColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: defGW[0],
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 4,
                          right: 8,
                        ),
                        child: Container(
                          height: 28,
                          color: foregroundColor,
                          width: 4,
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => showWeightToolTip(context, direction: PreferDirection.topLeft),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            UpdatingSetText(
                              isWeight: true,
                              excercise: widget.excercise,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                top: 2,
                                right: 4,
                              ),
                              child: Icon(
                                FontAwesomeIcons.dumbbell,
                                size: 12,
                                color: foregroundColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 1.0,
                        ),
                        child: Icon(
                          FontAwesomeIcons.times,
                          size: 12,
                          color: foregroundColor,
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => showRepsToolTip(context, direction: PreferDirection.topRight),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            UpdatingSetText(
                              isWeight: false,
                              excercise: widget.excercise,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                top: 2,
                              ),
                              child: Icon(
                                Icons.repeat,
                                size: 12,
                                color: foregroundColor,
                              ),
                            ),
                          ]
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpdatingSetText extends StatefulWidget {
  UpdatingSetText({
    @required this.isWeight,
    this.excercise,
  });

  final AnExcercise excercise;
  final bool isWeight;

  @override
  _UpdatingSetTextState createState() => _UpdatingSetTextState();
}

class _UpdatingSetTextState extends State<UpdatingSetText> {
  updateState(){
    if(mounted) setState(() {});
  }

  @override
  void initState() {
    //super init
    super.initState();

    //add listners if necessary
    if(widget.excercise == null){
      ExcercisePage.setGoalWeight.addListener(updateState);
      ExcercisePage.setGoalReps.addListener(updateState);
    }
  }

  @override
  void dispose() {
    //remove listeners if necessary
    if(widget.excercise == null){
      ExcercisePage.setGoalWeight.removeListener(updateState);
      ExcercisePage.setGoalReps.removeListener(updateState);
    }

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int value;
    if(widget.excercise == null){
      if(widget.isWeight) value = ExcercisePage.setGoalWeight.value;
      else value = ExcercisePage.setGoalReps.value;
    }
    else{
      if(widget.isWeight) value = widget.excercise.lastWeight;
      else value = widget.excercise.lastReps;
    }

    //widget
    return Text(value.toString());
  }
}