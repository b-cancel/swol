import 'package:flutter/material.dart';
import 'package:swol/shared/functions/goldenRatio.dart';

class CalibrationCard extends StatelessWidget {
  const CalibrationCard({
    Key key,
    @required this.rawSpaceToRedistribute,
    this.removeBottomButtonSpacing: false,
    this.removeDoneButtonSpacing: true,
  }) : super(key: key);

  final double rawSpaceToRedistribute;
  final bool removeDoneButtonSpacing;
  final bool removeBottomButtonSpacing;

  @override
  Widget build(BuildContext context) {
    double spaceToRedistribute = rawSpaceToRedistribute;

    //make instinct based removals since all the UI is semi contected
    if(removeDoneButtonSpacing){
      //NOTE: 48 is the padding between bottom buttons and our card
      spaceToRedistribute -= 48;
    }

    if(removeBottomButtonSpacing){
      //NOTE: 64 is the height of the bottom buttons
      spaceToRedistribute -= 64;
    }
    
    //calculate golden ratio
    List<double> bigToSmall = measurementToGoldenRatio(spaceToRedistribute);
    
    //card radius
    Radius cardRadius = Radius.circular(24);

    //minor setting
    double stepFontSize = 18;

    //build
    return Container(
      height: spaceToRedistribute,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            //color: Colors.blue,
            height: bigToSmall[1] - 8,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            height: 16,
            //color: Colors.red,
            width: MediaQuery.of(context).size.width,
            child: OverflowBox(
              maxHeight: spaceToRedistribute,
              minHeight: 0,
              child: Padding(
                padding: EdgeInsets.only(
                  left : 0.0,
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.only(
                      topLeft: cardRadius,
                      bottomLeft: cardRadius,
                      //----
                      topRight: cardRadius,
                      bottomRight: cardRadius,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
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
                          bottom: 24.0,
                          left: 8,
                        ),
                        child: Text(
                          "Without a previous set, we can't give you suggestions",
                          style: TextStyle(
                            fontSize: 22,
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
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            //color: Colors.green,
            height: bigToSmall[0] - 8,
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }
}

class BottomButtonPadding extends StatelessWidget {
  const BottomButtonPadding({
    this.withDoneButton: true,
    Key key,
  }) : super(key: key);

  final bool withDoneButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      //24 (p1) is for 24 away from the RIGHT BOTTOM buttons
      //24 (p2) is for 24 cuz of the curve
      height: 24.0 + ((withDoneButton) ? 24 : 0),
      width: MediaQuery.of(context).size.width,
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
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(12),
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
            padding: EdgeInsets.only(
              top: 8,
              bottom: 24,
              right: 16,
              left: 8,
            ),
            child: content,
          ),
        ),
      ],
    );
  }
}