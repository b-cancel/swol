import 'package:flutter/material.dart';

/*
class CalibrationBody extends StatelessWidget {
  const CalibrationBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double stepFontSize = 18;
    return ;
  }
}
*/

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