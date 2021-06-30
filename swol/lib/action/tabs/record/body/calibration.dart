//flutter
import 'package:flutter/material.dart';
import 'package:swol/shared/widgets/simple/curvedCorner.dart';

//internal
import 'package:swol/shared/widgets/simple/listItem.dart';
import 'package:swol/shared/functions/goldenRatio.dart';

//widget
class CalibrationHeader extends StatelessWidget {
  CalibrationHeader({
    required this.header,
  });

  final String header;
  //top round false
  //a little smaler false

  @override
  Widget build(BuildContext context) {
    //calculate header size
    List<double> goldenBS = measurementToGoldenRatioBS(
      MediaQuery.of(context).size.width,
    );

    //build
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: goldenBS[0],
                padding: EdgeInsets.symmetric(
                  vertical: 4,
                ),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    child: Text(header),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Transform.translate(
            offset: Offset(0, 24),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CurvedCorner(
                  isTop: true,
                  isLeft: true,
                  cornerColor: Theme.of(context).accentColor,
                ),
                CurvedCorner(
                  isTop: true,
                  isLeft: false,
                  cornerColor: Theme.of(context).accentColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//widget
class CalibrationBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //minor setting
    TextStyle defaultTextStyle = TextStyle(fontSize: 16);

    //widget to be golden ratio centered
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        /*
        Padding(
          padding: EdgeInsets.only(
            bottom: 24.0,
          ),
          child: Text(
            "Without a previous set, we can't give you suggestions",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        */
        ListItem(
          circleText: "1",
          circleSize: 18,
          circleColor: Theme.of(context).accentColor,
          content: RichText(
            textScaleFactor: MediaQuery.of(
              context,
            ).textScaleFactor,
            text: TextSpan(
              style: defaultTextStyle,
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
                  text: " 5 reps",
                ),
              ],
            ),
          ),
        ),
        ListItem(
          circleText: "2",
          circleSize: 18,
          circleColor: Theme.of(context).accentColor,
          content: RichText(
            textScaleFactor: MediaQuery.of(
              context,
            ).textScaleFactor,
            text: TextSpan(
              style: defaultTextStyle,
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
              ],
            ),
          ),
        ),
        ListItem(
          circleText: "3",
          circleSize: 18,
          circleColor: Theme.of(context).accentColor,
          bottomSpacing: 0,
          content: RichText(
            textScaleFactor: MediaQuery.of(
              context,
            ).textScaleFactor,
            text: TextSpan(
              style: defaultTextStyle,
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
