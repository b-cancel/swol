//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//internal
import 'package:swol/shared/functions/goldenRatio.dart';

//widget
class SetDisplay extends StatelessWidget {
  const SetDisplay({
    Key key,
    this.useAccent: false,
    @required this.title,
    @required this.lastWeight,
    @required this.lastReps,
    this.extraCurvy: false,
  }) : super(key: key);

  final bool useAccent;
  final String title;
  final int lastWeight;
  final int lastReps;
  final bool extraCurvy;

  @override
  Widget build(BuildContext context) {
    List<double> defGW = measurementToGoldenRatioBS(250);
    double curveValue = extraCurvy ? 48 : 24;
    double difference = 12;

    Color stuffColor = useAccent ? Theme.of(context).primaryColorDark : Colors.white;

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: useAccent ? Theme.of(context).accentColor : Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(curveValue),
          bottomRight: Radius.circular(curveValue),
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
              color: stuffColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: defGW[1],
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: stuffColor,
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
                          color: stuffColor,
                          width: 4,
                        ),
                      ),
                      Text(lastWeight.toString()),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(
                          top: 2,
                          right: 4,
                        ),
                        child: Icon(
                          FontAwesomeIcons.dumbbell,
                          size: 12,
                          color: stuffColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 1.0,
                        ),
                        child: Icon(
                          FontAwesomeIcons.times,
                          size: 12,
                          color: stuffColor,
                        ),
                      ),
                      Text(lastReps.toString()),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(
                          top: 2,
                        ),
                        child: Icon(
                          Icons.repeat,
                          size: 12,
                          color: stuffColor,
                        ),
                      ),
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