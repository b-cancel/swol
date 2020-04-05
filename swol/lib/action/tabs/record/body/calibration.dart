//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/simple/listItem.dart';
import 'package:swol/shared/functions/goldenRatio.dart';
import 'package:swol/action/shared/cardWithHeader.dart';

//widget
class CalibrationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //minor setting
    TextStyle defaultTextStyle = TextStyle(fontSize: 16);

    //to make title nice size
    double feelsGoodWidth = MediaQuery.of(context).size.width;
    List<double> goldenWidth = measurementToGoldenRatioBS(feelsGoodWidth);
    List<double> goldenWidth2 = measurementToGoldenRatioBS(goldenWidth[1]);

    //widget to be golden ratio centered
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        CardWithHeader(
          header: "Calibration Set",
          topRound: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  bottom: 24.0,
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: goldenWidth[0] + goldenWidth2[0],
                      child: Text(
                        "Without a previous set, we can't give you suggestions",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              ListItem(
                circleText: "1",
                circleSize: 36,
                circleColor: Theme.of(context).accentColor,
                content: RichText(
                  textScaleFactor: MediaQuery.of(
                    context,
                  ).textScaleFactor,
                  text: TextSpan(style: defaultTextStyle, children: [
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
                      text: " 5 reps",
                    ),
                  ]),
                ),
              ),
              ListItem(
                circleText: "2",
                circleSize: 36,
                circleColor: Theme.of(context).accentColor,
                content: RichText(
                  textScaleFactor: MediaQuery.of(
                    context,
                  ).textScaleFactor,
                  text: TextSpan(style: defaultTextStyle, children: [
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
                  ]),
                ),
              ),
              ListItem(
                circleText: "3",
                circleSize: 36,
                circleColor: Theme.of(context).accentColor,
                bottomSpacing: 0,
                content: RichText(
                  textScaleFactor: MediaQuery.of(
                    context,
                  ).textScaleFactor,
                  text: TextSpan(style: defaultTextStyle, children: [
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
                  ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
