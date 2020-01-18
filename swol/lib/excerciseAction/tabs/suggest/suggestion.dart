//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/excerciseAddition/popUps/popUpFunctions.dart';

//internal
import 'package:swol/excerciseAddition/secondary/sections/predictionFunction.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/excerciseAddition/secondary/sections/repTarget.dart';
import 'package:swol/other/functions/helper.dart';
import 'package:swol/sharedWidgets/informationDisplay.dart';
import 'package:swol/sharedWidgets/mySlider.dart';
import 'package:swol/utils/goldenRatio.dart';

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
    List<double> bigToSmall = measurementToGoldenRatio(
      rawSpaceToRedistribute,
    );

    List<double> secondBigToSmall = measurementToGoldenRatio(
      bigToSmall[1],
    );

    double largerSpace = rawSpaceToRedistribute - (secondBigToSmall[0] * 2);

    //GOAL
    //super small
    //large
    //semi small
    
    //card radius
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
            height: secondBigToSmall[0],
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: cardRadius,
                  bottomRight: cardRadius,
                ),
              ),
              padding: EdgeInsets.all(16),
              child: ShowSet(
                isLast: true,
                lastWeight: 9, 
                lastReps: 8,
              ),
            ),
          ),
          FunctionSettings(
            height: largerSpace,
            functionIndex: functionIndex, 
            functionString: functionString,
          ),
          //-----Most Important Part 
          //1. tells the user what to next
          //2. lets the user change the rep target If needed
          Container(
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
                lastWeight: 1111, 
                lastReps: 222,
              ),
              
              /*Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 8,
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: Column(
                      children: <Widget>[
                        HeaderWithInfo(
                          title: "Rep Target",
                          popUpFunction: () => repTargetPopUp(context),
                        ),
                        Theme(
                          data: ThemeData.light(),
                          child: AnimRepTargetInfoWhite(
                            changeDuration: Duration(milliseconds: 300), 
                            repTargetDuration: new ValueNotifier<Duration>(
                              Duration(milliseconds: 300),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Container(
                            color: Colors.black, //line color
                            height: 2,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //slide must be full width without the 16 horizontal padding
                  CustomSlider(
                    value: new ValueNotifier<int>(5),
                    lastTick: 35,
                  ),
                ],
              ),
              */
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
    return IntrinsicHeight(
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
                    Text(isLast ? "Last" : "Goal"),
                    Text("Set"),
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
    );
  }
}

class FunctionSettings extends StatelessWidget {
  const FunctionSettings({
    Key key,
    @required this.height,
    @required this.functionIndex,
    @required this.functionString,
  }) : super(key: key);

  final double height;
  final ValueNotifier<int> functionIndex;
  final ValueNotifier<String> functionString;

  @override
  Widget build(BuildContext context) {
    //card radius
    Radius cardRadius = Radius.circular(24);

    //build
    return Stack(
      children: <Widget>[
        Container(
          height: height,
          /*
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: Colors.white.withOpacity(1),
              fontSize: 64,
              fontWeight: FontWeight.w300,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    right: 4.0,
                  ),
                  child: Text(
                    "f",
                    style: TextStyle(
                      fontSize: 82,
                      fontWeight: FontWeight.w200,
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
          */
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
      height: 24,
      width: 24,
      color: Theme.of(context).cardColor,
    );
    
    Widget backColored = Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.only(
          bottomRight: cardRadius,
          bottomLeft: cardRadius,
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
      height: 36,
      width: 36,
      child: child,
    );
  }
}