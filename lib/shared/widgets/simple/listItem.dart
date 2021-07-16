import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  ListItem({
    required this.content,
    this.rightPadding: 8,
    this.circleText = "",
    this.circleTextColor = Colors.black,
    this.circleColor = Colors.white,
    this.circlePadding = 2,
    this.circleSize,
    this.bottomSpacing = 12.0,
  });

  final Widget content;
  final double rightPadding;

  final String circleText;
  final Color circleTextColor;

  final Color circleColor;
  final double circlePadding;
  final double? circleSize;

  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    double actualCircleSize;
    if (circleSize != null) {
      actualCircleSize = circleSize!;
    } else {
      if (circleText == "")
        actualCircleSize = 12;
      else
        actualCircleSize = 18;
    }

    return Container(
      margin: EdgeInsets.only(bottom: bottomSpacing),
      child: IntrinsicHeight(
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: rightPadding),
              alignment: Alignment.topLeft,
              child: Container(
                width: (circlePadding * 2) + actualCircleSize,
                height: (circlePadding * 2) + actualCircleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor,
                ),
                child: Padding(
                  padding: EdgeInsets.all(circlePadding),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: new Text(
                      circleText,
                      style: TextStyle(
                        color: circleTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            new Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: circleText == "" ? 0 : circlePadding,
                ),
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
