import 'package:flutter/material.dart';

class CalibrationBody extends StatelessWidget {
  const CalibrationBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double stepFontSize = 18;
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 0.0,
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                child: Text("Calibration Set")
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 16.0,
              left: 8,
            ),
            child: Text(
              "Without a previous set, we can't give you suggestions",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          new CalibrationStep(
            number: 1,
            content: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: stepFontSize,
                ),
                children: [
                  TextSpan(
                    text: "Pick ",
                  ),
                  TextSpan(
                    text: "any",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " weight you ",
                  ),
                  TextSpan(
                    text: "know",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " you can lift for ",
                  ),
                  TextSpan(
                    text: "around",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " 10 reps",
                  ),
                ]
              ),
            ),
          ),
          new CalibrationStep(
            number: 2,
            content: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: stepFontSize,
                ),
                children: [
                  TextSpan(
                    text: "Do as many reps as ",
                  ),
                  TextSpan(
                    text: "possible",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " with ",
                  ),
                  TextSpan(
                    text: "good",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " form",
                  ),
                ]
              ),
            ),
          ),
          new CalibrationStep(
            number: 3,
            content: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: stepFontSize,
                ),
                children: [
                  TextSpan(
                    text: "Record the weight you used and your ",
                  ),
                  TextSpan(
                    text: "maximum reps",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " so we can begin giving you suggestions",
                  ),
                ]
              ),
            ),
          ),
          Expanded(
            child: Container(),
          )
        ],
      ),
    );
  }
}

class CalibrationStep extends StatelessWidget {
  const CalibrationStep({
    Key key,
    @required this.number,
    @required this.content,
  }) : super(key: key);

  final int number;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            decoration: new BoxDecoration(
              color: Theme.of(context).accentColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(
                16,
              ),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}