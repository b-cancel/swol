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
        bottom: 16.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.5),
            )
          )
        ),
        padding: EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
          child: child,
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  ListItem({
    this.content,
    this.circleColor = Colors.white,
    this.circleSize = 12.0,
    this.circleText = "",
    this.circleTextColor = Colors.black,
    this.circleTextSize = 12.0,
    this.bottomSpacing = 16.0,
    this.circlePadding = 4,
  });

  final Widget content;

  final Color circleColor;
  final double circleSize;

  final String circleText;
  final Color circleTextColor;
  final double circleTextSize;

  final double bottomSpacing;

  final double circlePadding;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            alignment: Alignment.center,
            width: circleTextSize,
            margin: EdgeInsets.only(right: circleTextSize),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(circlePadding),
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
          new Expanded(
            child: new Container(
              margin: EdgeInsets.only(bottom: bottomSpacing),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}