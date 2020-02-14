//flutter
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:swol/action/shared/setToolTips.dart';

//plugin
import 'package:vector_math/vector_math_64.dart' as vect;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//internal
import 'package:swol/shared/functions/goldenRatio.dart';

//widget
class SetDisplay extends StatefulWidget {
  const SetDisplay({
    Key key,
    @required this.title,
    @required this.lastWeight,
    @required this.lastReps,
    this.extraCurvy: false,
    @required this.useAccent,
    //optional
    this.heroUp,
    this.heroAnimDuration,
    this.heroAnimTravel,
  }) : super(key: key);

  final String title;
  final int lastWeight;
  final int lastReps;
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
                        onTap: () => showWeightToolTip(context, direction: PreferDirection.topLeft),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(widget.lastWeight.toString()),
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
                        onTap: () => showRepsToolTip(context, direction: PreferDirection.topRight),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(widget.lastReps.toString()),
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