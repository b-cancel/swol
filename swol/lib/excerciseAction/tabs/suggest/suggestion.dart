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
    TextStyle bigStyle = TextStyle(
      fontSize: 64,
      fontWeight: FontWeight.bold,
    );

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
            bigStyle: bigStyle, 
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
    @required this.bigStyle,
    @required this.functionIndex,
    @required this.functionString,
  }) : super(key: key);

  final List<double> secondBigToSmall;
  final TextStyle bigStyle;
  final ValueNotifier<int> functionIndex;
  final ValueNotifier<String> functionString;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: secondBigToSmall[1],
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: DefaultTextStyle(
        style: bigStyle,
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
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Text("{"),
            Expanded(
              child: FunctionDropDown(
                functionIndex: functionIndex,
                functionString: functionString,
              ),
            ),
            Text("}"),
          ],
        ),
      ),
    );
  }
}

class SettingButton extends StatelessWidget {
  const SettingButton({
    Key key,
    @required this.onPressed,
    @required this.icon,
    @required this.name,
    @required this.value,
  }) : super(key: key);

  final Function onPressed;
  final IconData icon;
  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  right: 8,
                ),
                child: Icon(
                  icon,
                ),
              ),
              Text(name + ": " + value),
            ],
          ),
          Icon(
            Icons.edit,
          )
        ],
      ),
    );
  }
}

class MyArrow extends StatelessWidget {
  const MyArrow({
    this.color,
    Key key,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Transform.rotate(
          angle: 0, //math.pi / 2,
          child: Icon(
            Icons.arrow_downward,
            color: color,
          )
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        LastSetText(),
                        TextSeparator(),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 116,
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
                                      top: 16,
                                      left: 4,
                                      right: 16,
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.dumbbell,
                                      size: 42,
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
                                      top: 16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "MAX",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 32,
                                          ),
                                        ),
                                        Text(
                                          "Reps",
                                          style: TextStyle(
                                            fontSize: 22,
                                          ),
                                        ),
                                      ],
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