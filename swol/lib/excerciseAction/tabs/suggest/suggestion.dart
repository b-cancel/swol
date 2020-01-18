import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/excerciseAddition/secondary/sections/predictionFunction.dart';
import 'package:swol/main.dart';
import 'package:swol/other/functions/helper.dart';
import 'package:swol/utils/goldenRatio.dart';

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
    //calculate golden ratio
    List<double> bigToSmall = measurementToGoldenRatio(
      rawSpaceToRedistribute,
    );

    List<double> secondBigToSmall = measurementToGoldenRatio(
      bigToSmall[1],
    );
    
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
            padding: EdgeInsets.only(
              bottom: 8,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: cardRadius,
                  bottomRight: cardRadius,
                ),
              ),
              child: LastSetDisplay(
                weight: "9999",
                reps: "111",
              ),
            ),
          ),
          FunctionChanger(
            secondBigToSmall: secondBigToSmall,
            functionIndex: functionIndex, 
            functionString: functionString,
          ),
          //-----Most Important Part 
          //1. tells the user what to next
          //2. lets the user change the rep target If needed
          Container(
            height: bigToSmall[0],
            padding: EdgeInsets.only(
              top: 8,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(
                  cardRadius,
                ),
              ),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16),
              child: Container(
                color: Colors.red,
              )
            ),
          ),
        ],
      ),
    );
  }
}

class FunctionChanger extends StatelessWidget {
  const FunctionChanger({
    Key key,
    @required this.secondBigToSmall,
    @required this.functionIndex,
    @required this.functionString,
  }) : super(key: key);

  final List<double> secondBigToSmall;
  final ValueNotifier<int> functionIndex;
  final ValueNotifier<String> functionString;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: secondBigToSmall[1],
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
    );
  }
}

class LastSetDisplay extends StatelessWidget {
  LastSetDisplay({
    @required this.weight,
    @required this.reps,
  });

  final String weight;
  final String reps;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              bottom: 0,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        LastSetText(),
                        TextSeparator(),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 96,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    weight,
                                    style: TextStyle(
                                      fontSize: 82,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 36,
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.times,
                                    ),
                                  ),
                                  Text(
                                    reps,
                                    style: TextStyle(
                                      fontSize: 82,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 16.0,
                                    ),
                                    child: Icon(
                                      Icons.repeat, 
                                      size: 32,
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TextSeparator extends StatelessWidget {
  const TextSeparator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16,
        top: 4,
        bottom: 4,
      ),
      child: Container(
        width: 4,
        color: Colors.white,
      ),
    );
  }
}

class LastSetText extends StatelessWidget {
  const LastSetText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.bold,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text("Last"),
          Text("Set"),
        ],
      ),
    );
  }
}

/*
          Expanded(
            child: SetDisplay(
              weight: lastWeight.toString(),
              reps: lastReps.toString(),
              isLast: true,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new MyArrow(
                color: (true) ? Colors.white : Theme.of(context).accentColor,
              ),
              new MyArrow(
                color: (true) ? Colors.white : Theme.of(context).accentColor,
              ),
            ],
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new MyArrow(
                color: (false) ? Colors.white : Theme.of(context).accentColor,
              ),
              new MyArrow(
                color: (false) ? Colors.white : Theme.of(context).accentColor,
              ),
            ],
          ),
          Expanded(
            child: SetDisplay(
              weight: (lastWeight * (2/3)).toInt().toString(),
              reps: (lastWeight * (3/2)).toInt().toString(),
              isLast: false,
            ),
          ),
          */