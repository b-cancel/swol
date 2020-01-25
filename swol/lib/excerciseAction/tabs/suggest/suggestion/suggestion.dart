//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/excerciseAction/tabs/suggest/suggestion/setDisplay.dart';
import 'package:swol/shared/functions/goldenRatio.dart';

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
      color: Colors.red,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SetDisplay(
            extraCurvy: true,
            title: "Last Set",
            lastWeight: 9999,
            lastReps: 888,
          ),
          Expanded(
            child: FunctionSettings(
              functionIndex: functionIndex,
              functionString: functionString,
              arrowRadius: arrowRadius,
              cardRadius: cardRadius,
            ),
          ),
          SetDisplay(
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
    @required this.functionIndex,
    @required this.functionString,
    @required this.arrowRadius,
    @required this.cardRadius,
  }) : super(key: key);

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
              child: Container(),
            ),
            Container(
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
            Expanded(
              child: Container(),
            ),
            
            RepTargetChanger(
              arrowRadius: arrowRadius,
            ),
            Expanded(
              child: Container(),
            ),
            /*
            //min height of ?
            TextOnBlack(
                        text: "we calculated you Goal Set to be",
                      ),
            */
          ],
        ),
      ],
    );
  }
}

/*
             Container(
               child: Stack(
                 children: <Widget>[
                   Stack(
                    children: <Widget>[
                      TextOnBlack(
                        text: "using your Last Set, Prediction Formula,",
                      ),
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
                    ],
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
            */















            /*
                Stack(
                  children: <Widget>[
                    TextOnBlack(
                      text: "and Rep Target",
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Corner(
                        cardRadius: cardRadius,
                        isLeft: true,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Corner(
                        cardRadius: cardRadius,
                      ),
                    ),
                  ],
                ),
                */

class RepTargetChanger extends StatelessWidget {
  const RepTargetChanger({
    Key key,
    @required this.arrowRadius,
  }) : super(key: key);

  final Radius arrowRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          bottomRight: arrowRadius,
          bottomLeft: arrowRadius,
        ),
      ),
      child: RepTargetField(
        //TODO: replace for the same value that all of add excercise has
        changeDuration: Duration(milliseconds: 300),
        repTarget: new ValueNotifier(1),
        subtle: true,
      ),
    );
  }
}

class TextOnBlack extends StatelessWidget {
  const TextOnBlack({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        //minimum is 8
        vertical: 12,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class Corner extends StatelessWidget {
  const Corner({
    Key key,
    @required this.cardRadius,
    this.isLeft: false,
  }) : super(key: key);

  final Radius cardRadius;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    Widget cardColored = Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          //right
          topLeft: isLeft ? Radius.zero : cardRadius,

          //left
          topRight: isLeft ? cardRadius : Radius.zero,
        ),
      ),
    );
    
    Widget backColored = Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.only(
          //right
          bottomRight: isLeft ? Radius.zero : cardRadius,
          topLeft: isLeft ? Radius.zero : cardRadius,

          //left
          bottomLeft: isLeft ? cardRadius : Radius.zero,
          topRight: isLeft ? cardRadius : Radius.zero,
        ),
      ),
    );

    Widget child;
    if(isLeft){
      child = Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            bottom: 0,
            child: cardColored,
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: backColored,
          ),
        ],
      );
    }
    else{
      child = Stack(
        children: <Widget>[
          Positioned(
            right: 0,
            bottom: 0,
            child: cardColored,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: backColored,
          ),
        ],
      );
    }

    return Container(
      height: 56,
      width: 56,
      child: child,
    );
  }
}