//flutter
import 'package:flutter/material.dart';
import 'package:swol/excerciseAction/tabs/record/changeFunction.dart';

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
    @required this.excercise,
    @required this.lastWeight,
    @required this.lastReps,
    @required this.rawSpaceToRedistribute,
    @required this.heroUp,
    @required this.heroAnimDuration,
    @required this.heroAnimTravel,
  }) : super(key: key);

  final AnExcercise excercise;
  final int lastWeight;
  final int lastReps;
  final double rawSpaceToRedistribute;
  final ValueNotifier<bool> heroUp;
  final Duration heroAnimDuration;
  final double heroAnimTravel;

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
          Stack(
            children: <Widget>[
              Positioned.fill(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                    Expanded(child: Container()),
                  ]
                ),
              ),
              SetDisplay(
                useAccent: false,
                extraCurvy: true,
                title: "Last Set",
                lastWeight: 9999,
                lastReps: 888,
              ),
            ],
          ),
          Expanded(
            child: FunctionSettings(
              excercise: excercise,
              arrowRadius: arrowRadius,
              cardRadius: cardRadius,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                bottomRight: cardRadius,
                bottomLeft: cardRadius,
              ),
            ),
            width: MediaQuery.of(context).size.width,
            child: SetDisplay(
              useAccent: true,
              title: "Goal Set",
              lastWeight: 124,
              lastReps: 23,
              heroUp: heroUp,
              heroAnimDuration: heroAnimDuration,
              heroAnimTravel: heroAnimTravel,
            ),
          ),
        ],
      ),
    );
  }
}

class FunctionSettings extends StatefulWidget {
  const FunctionSettings({
    Key key,
    @required this.excercise,
    @required this.arrowRadius,
    @required this.cardRadius,
  }) : super(key: key);

  final AnExcercise excercise;
  final Radius arrowRadius;
  final Radius cardRadius;

  @override
  _FunctionSettingsState createState() => _FunctionSettingsState();
}

class _FunctionSettingsState extends State<FunctionSettings> {
  ValueNotifier<int> repTarget;

  //updating function
  updateRepTarget() {
    widget.excercise.repTarget = repTarget.value;
  }

  //init
  @override
  void initState() {
    //super init
    super.initState();

    //create notifiers
    repTarget = new ValueNotifier<int>(widget.excercise.repTarget);

    //add listeners
    repTarget.addListener(updateRepTarget);
  }

  //dispose
  @override
  void dispose() { 
    //remove listeners
    repTarget.removeListener(updateRepTarget);

    //dispose notifiers
    repTarget.dispose();

    //super dispose
    super.dispose();
  }

  //build
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //the two corners that "attach" to the goal set card
        Positioned(
          left: 0,
          bottom: 0,
          child: Corner(
            cardRadius: widget.arrowRadius,
            isLeft: true,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Corner(
            cardRadius: widget.arrowRadius,
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
                   text: "using your Prediction Formula",
                   radius: widget.arrowRadius
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
                    bottomRight: widget.cardRadius,
                    bottomLeft: widget.cardRadius,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      PredictionFormulaHeader(
                        subtle: true,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 8.0,
                        ),
                        child: ChangeFunction(
                          excercise: widget.excercise, 
                          middleArrows: false,
                        ),
                      ),
                    ],
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
                  text: "and your Rep Target",
                  radius: widget.cardRadius,
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
                    bottomRight: widget.arrowRadius,
                    bottomLeft: widget.arrowRadius,
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
                text: "your next set should be",
                radius: widget.arrowRadius,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FunctionSettings2 extends StatelessWidget {
  const FunctionSettings2({
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
                   text: "using your Prediction Formula",
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
                  child: FunctionDropDown(
                    functionIndex: functionIndex,
                    functionString: functionString,
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
                  text: "and your Rep Target",
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
                  top: 16,
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
                text: "your next set should be",
                radius: arrowRadius,
              ),
            ),
          ],
        ),
      ],
    );
  }
}