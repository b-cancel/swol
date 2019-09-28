import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

class SetDisplay extends StatelessWidget {
  SetDisplay({
    @required this.isLast,
    @required this.weight,
    @required this.reps,
  });

  final bool isLast;
  final String weight;
  final String reps;

  @override
  Widget build(BuildContext context) {
    Color theColor = (isLast) ? Colors.white : Theme.of(context).accentColor;

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: theColor,
          width: 2,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Text(
                  (isLast) ? "Last Set" : "Goal Set",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      weight,
                      style: TextStyle(
                        fontSize: 48,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 4,
                      ),
                      child: Transform.translate(
                        offset: Offset(0, -10),
                        child: Icon(
                          FontAwesomeIcons.dumbbell,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                      ),
                      child: Text(
                        reps,
                        style: TextStyle(
                          fontSize: 48,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, -4),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 4,
                          right: 4,
                        ),
                        child: Text(
                          (isLast) ? "MAX Reps" : "MIN Reps",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class CalibStep extends StatelessWidget {
  const CalibStep({
    Key key,
    @required this.stepNumber,
  }) : super(key: key);

  final int stepNumber;

  @override
  Widget build(BuildContext context) {
    double fontSize = 18;

    Widget step;
    if(stepNumber == 1){
      step = RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: fontSize,
          ),
          children: [
            TextSpan(
              text: "Pick ",
            ),
            TextSpan(
              text: "ANY",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: " weight you ",
            ),
            TextSpan(
              text: "KNOW",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: " you can lift for ",
            ),
            TextSpan(
              text: "AROUND",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: " 10 reps",
            ),
          ]
        ),
      );
    }
    else if(stepNumber == 2){
      step = RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: fontSize,
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
      );
    }
    else{
      step = RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: fontSize,
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
      );
    }

    //build
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
                stepNumber.toString(),
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
              child: step,
            ),
          ),
        ],
      ),
    );
  }
}