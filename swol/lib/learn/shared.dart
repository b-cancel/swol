//flutter
import 'package:flutter/material.dart';

class SectionDescription extends StatelessWidget {
  const SectionDescription({
    Key key,
    @required this.children,
  }) : super(key: key);

  final List<TextSpan> children;

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
            width: MediaQuery.of(context).size.width,
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                children: children,
              )
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
  final double circleSize;

  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    double actualCircleSize;
    if(circleSize != null) actualCircleSize = circleSize;
    else{
      if(circleText == "") actualCircleSize = 12;
      else actualCircleSize = 18;
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