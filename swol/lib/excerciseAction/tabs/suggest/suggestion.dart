//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//internal: addition
import 'package:swol/excerciseAddition/secondary/sections/predictionFunction.dart';
import 'package:swol/excerciseAddition/secondary/sections/repTarget.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/settingHeaders/headerWithInfoButton.dart';
import 'package:swol/shared/widgets/simple/ourSlider.dart';
import 'package:swol/shared/functions/theme.dart';

//internal: other
import 'package:swol/excercise/excerciseStructure.dart';
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
    //calculate golden ratios
    List<double> bigToSmall = [
      rawSpaceToRedistribute * (2/3),
      rawSpaceToRedistribute * (1/3),
    ];

    List<double> secondBigToSmall = [
      bigToSmall[1] * (2/3),
      bigToSmall[1] * (1/3),
    ];

    //GOAL
    //super small
    //large
    //semi small
    
    //card radius
    Radius arrowRadius = Radius.circular(48);
    Radius cardRadius = Radius.circular(24);

    return Container(
      height: rawSpaceToRedistribute,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: secondBigToSmall[1],
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: arrowRadius,
                  bottomRight: arrowRadius,
                ),
              ),
              padding: EdgeInsets.all(16),
              child: ShowSet(
                lastWeight: 9999, 
                lastReps: 888,
                isLast: true,
              ),
            ),
          ),
          FunctionSettings(
            height: bigToSmall[0],
            functionIndex: functionIndex, 
            functionString: functionString,
            arrowRadius: arrowRadius,
            cardRadius: cardRadius,
          ),
          //-----Most Important Part 
          //1. tells the user what to next
          //2. lets the user change the rep target If needed
          Hero(
            tag: 'goalSet',
            child: Container(
              height: secondBigToSmall[0],
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: cardRadius,
                    bottomLeft: cardRadius,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16),
                child: ShowSet(
                  lastWeight: 160, 
                  lastReps: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShowSet extends StatelessWidget {
  const ShowSet({
    Key key,
    @required this.lastWeight,
    @required this.lastReps,
    this.isLast: false,
  }) : super(key: key);

  final int lastWeight;
  final int lastReps;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isLast ? 16 : 0,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: FittedBox(
                fit: BoxFit.contain,
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        (isLast ? "Last" : "Goal") 
                        + (isLast ? " Set" : "")
                      ),
                      isLast ? Container() : Text("Set"),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: 4,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(lastWeight.toString()),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(
                          top: 2,
                          right: 4,
                        ),
                        child: Icon(
                          FontAwesomeIcons.dumbbell,
                          size: 6,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 1.0,
                        ),
                        child: Icon(
                          FontAwesomeIcons.times,
                          size: 6,
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
                          size: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FunctionSettings extends StatelessWidget {
  const FunctionSettings({
    Key key,
    @required this.height,
    @required this.functionIndex,
    @required this.functionString,
    @required this.arrowRadius,
    @required this.cardRadius,
  }) : super(key: key);

  final double height;
  final ValueNotifier<int> functionIndex;
  final ValueNotifier<String> functionString;
  final Radius arrowRadius;
  final Radius cardRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            vertical: 24,
          ),
          child: Container(
            padding: EdgeInsets.only(
              bottom: 24,
            ),
            child: Container(
            ),
          ),
          /*
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: 
          ),
          */
        ),
        Container(
          height: height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
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
                    )
                    /*
                    Positioned.fill(
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              color: Theme.of(context).cardColor,
                            ),
                          ],
                        ),
                      ),
                    )

                    */
                   ],
              ),
               ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
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
                            child: FunctionChanger(
                              functionIndex: functionIndex, 
                              functionString: functionString,
                            ),
                          ),
                        ),
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
                        Expanded(
                          child: RepTargetChanger(
                            arrowRadius: arrowRadius,
                          ),
                        ),
                        TextOnBlack(
                          text: "we calculated you Goal Set to be",
                        ),
                      ],
                    ),
                    
                    /*
                    DefaultTextStyle(
                      style: TextStyle(
                        color: Colors.white.withOpacity(1),
                        fontSize: 64,
                        fontWeight: FontWeight.w300,
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              color: Colors.pink,
                              padding: const EdgeInsets.only(
                                right: 4.0,
                              ),
                              width: 32,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  "f",
                                  style: TextStyle(
                                    fontSize: 128,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ),
                            ),
                            Text("{"),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: FunctionDropDown(
                                  functionIndex: functionIndex,
                                  functionString: functionString,
                                ),
                              ),
                            ),
                            Text("}"),
                          ],
                        ),
                      ),
                    ),
                    */
                  ),
                ),
              ),
            ],
          ),
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
    );
  }
}

class FunctionChanger extends StatelessWidget {
  const FunctionChanger({
    Key key,
    @required this.functionIndex,
    @required this.functionString,
  }) : super(key: key);

  final ValueNotifier<int> functionIndex;
  final ValueNotifier<String> functionString;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        PredictionFormulaHeader(
          subtle: true,
        ),
        FunctionDropDown(
          functionIndex: functionIndex,
          functionString: functionString,
        ),
      ],
    );
  }
}

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Container(
              padding: EdgeInsets.only(
                top: 0,
                bottom: 16,
              ),
              child: Column(
                children: <Widget>[
                  RepTargetHeader(
                    subtle: true,
                  ),
                  Theme(
                    data: MyTheme.light,
                    child: AnimRepTargetInfoWhite(
                      changeDuration: Duration(milliseconds: 300), 
                      repTargetDuration: new ValueNotifier<Duration>(
                        Duration(milliseconds: 300),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Container(
                      color: Colors.black, //line color
                      height: 2,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //slide must be full width without the 16 horizontal padding
          CustomSlider(
            value: new ValueNotifier<int>(1),
            lastTick: 35,
          ),
        ],
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