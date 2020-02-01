//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:swol/excerciseAction/tabs/suggest/suggestion/setDisplay.dart';
import 'package:swol/excerciseAction/tabs/suggest/suggestion/corners.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/fields/fields/sliders/repTarget.dart';
import 'package:swol/shared/widgets/complex/fields/fields/function.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//internal: other
import 'package:swol/other/functions/helper.dart';

//includes both calibration and the suggestion
class SuggestionSection extends StatelessWidget {
  SuggestionSection({
    Key key,
    @required this.lastWeight,
    @required this.lastReps,
    @required this.rawSpaceToRedistribute,
  }) : super(key: key);

  final int lastWeight;
  final int lastReps;
  final double rawSpaceToRedistribute;

  //TODO: grab actual values from excercise reference
  final ValueNotifier<int> repTarget = new ValueNotifier(
    AnExcercise.defaultRepTarget,
  );
  final ValueNotifier<int> functionIndex = new ValueNotifier(
    AnExcercise.defaultFunctionID,
  );
  final ValueNotifier<String> functionString = new ValueNotifier(
    Functions.functions[AnExcercise.defaultFunctionID]
  );

  @override
  Widget build(BuildContext context) {
    //card radius
    Radius arrowRadius = Radius.circular(48);
    Radius cardRadius = Radius.circular(24);

    //return
    return Container(
      height: rawSpaceToRedistribute,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SetDisplay(
            useAccent: false,
            extraCurvy: true,
            title: "Last Set",
            lastWeight: 9999,
            lastReps: 888,
          ),
          Expanded(
            child: FunctionSettings(
              repTarget: repTarget,
              functionIndex: functionIndex,
              functionString: functionString,
              arrowRadius: arrowRadius,
              cardRadius: cardRadius,
            ),
          ),
          SetDisplay(
            useAccent: true,
            title: "Goal Set",
            lastWeight: 124,
            lastReps: 23,
          ),
        ],
      ),
    );
  }
}

class FunctionSettings extends StatelessWidget {
  const FunctionSettings({
    Key key,
    @required this.repTarget,
    @required this.functionIndex,
    @required this.functionString,
    @required this.arrowRadius,
    @required this.cardRadius,
  }) : super(key: key);

  final ValueNotifier<int> repTarget;
  final ValueNotifier<int> functionIndex;
  final ValueNotifier<String> functionString;
  final Radius arrowRadius;
  final Radius cardRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //the two corners that "attach" to the goal set card
        Positioned(
          left: 0,
          bottom: 0,
          child: Corner(
            cardRadius: arrowRadius,
            isLeft: true,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Corner(
            cardRadius: arrowRadius,
          ),
        ),
        //everything else
        Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  TextWithCorners(
                   text: "using your Last Set",
                   radius: arrowRadius
                 ),
                 Positioned.fill(
                   child: Container(
                     child: Row(
                       children: <Widget>[
                         Container(
                           color: Theme.of(context).primaryColorDark,
                           width: 24,
                         ),
                         Expanded(
                           child: Container(),
                         ),
                         Container(
                           color: Theme.of(context).primaryColorDark,
                           width: 24,
                         )
                       ],
                     ),
                   ),
                 ),
               ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.0,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: cardRadius,
                    bottomLeft: cardRadius,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: PredictionField(
                    functionIndex: functionIndex, 
                    functionString: functionString,
                    subtle: true,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: TextWithCorners(
                  text: "your selected Prediction Formula",
                  radius: cardRadius,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.0,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: arrowRadius,
                    bottomLeft: arrowRadius,
                  ),
                ),
                padding: EdgeInsets.only(
                  bottom: 12,
                ),
                child: RepTargetField(
                  changeDuration: Duration(milliseconds: 300),
                  repTarget: repTarget,
                  subtle: true,
                ),
              ),
            ),
            Expanded(
              child: TextWithCorners(
                useAccent: true,
                text: "and your Rep Target\nyour Goal Set should be",
                radius: arrowRadius,
              ),
            ),
          ],
        ),
      ],
    );
  }
}