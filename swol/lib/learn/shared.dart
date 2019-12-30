//flutter
import 'package:flutter/material.dart';

class SectionDescription extends StatelessWidget {
  const SectionDescription({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              child: child,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.5),
                  )
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  ListItem({
    this.content,
    this.rightPadding: 8,

    this.circleText = "",
    this.circleTextColor = Colors.black,
    this.circleTextSize = 14.0,

    this.circleColor = Colors.white,
    this.circlePadding = 2,
    
    this.bottomSpacing = 12.0,
  });

  final Widget content;
  final double rightPadding;

  final String circleText;
  final Color circleTextColor;
  final double circleTextSize;

  final Color circleColor;
  final double circlePadding;

  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
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
                width: (circlePadding * 2) + circleTextSize,
                height: (circlePadding * 2) + circleTextSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor,
                ),
                child: Padding(
                  padding: EdgeInsets.all(circlePadding),
                  child: Center(
                    child: new Text(
                      circleText,
                      style: TextStyle(
                        color: circleTextColor,
                        fontSize: circleTextSize,
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