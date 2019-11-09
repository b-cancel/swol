import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SuggestionBody extends StatelessWidget {
  const SuggestionBody({
    Key key,
    @required this.lastWeight,
    @required this.lastReps,
  }) : super(key: key);

  final int lastWeight;
  final int lastReps;

  @override
  Widget build(BuildContext context) {
    TextStyle bigStyle = TextStyle(
      fontSize: 64,
      fontWeight: FontWeight.bold,
    );

    return Padding(
      padding: EdgeInsets.only(top:16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
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
            Container(
              color: Colors.red,
              width: MediaQuery.of(context).size.width,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "f",
                      style: bigStyle,
                    ),
                    Text(
                      "(",
                      style: bigStyle,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("easy wording"),
                        Text("change rep target with pop up UI"),
                        Text("change prediction target with pop up UI"),
                        Text("easy conclusion"),
                      ],
                    ),
                    Text(
                      "}",
                      style: bigStyle,
                    ),
                  ],
                ),
              )
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