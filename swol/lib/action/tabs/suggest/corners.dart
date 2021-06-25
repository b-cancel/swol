import 'package:flutter/material.dart';

class TextWithCorners extends StatelessWidget {
  const TextWithCorners({
    Key? key,
    required this.text,
    this.radius,
    this.useAccent: false,
  }) : super(key: key);

  final String text;
  final Radius? radius;
  final bool useAccent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (radius == null) ? 24 : 0,
      ),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              //TODO: is this how I want to handle this?
              horizontal: (radius?.x ?? 24),
            ),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Visibility(
              visible: radius != null,
              child: Corner(
                cornerColor: useAccent
                    ? Theme.of(context).accentColor
                    : Theme.of(context).cardColor,
                cardRadius: radius!,
                isLeft: true,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Visibility(
              visible: radius != null,
              child: Corner(
                cardRadius: radius!,
                cornerColor: useAccent
                    ? Theme.of(context).accentColor
                    : Theme.of(context).cardColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Corner extends StatelessWidget {
  const Corner({
    Key? key,
    this.cornerColor,
    this.backgroundColor,
    required this.cardRadius,
    this.isLeft: false,
  }) : super(key: key);

  final Color? cornerColor;
  final Color? backgroundColor;
  final Radius cardRadius;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    Widget cardColored = Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: cornerColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          //right
          topLeft: isLeft ? Radius.zero : cardRadius,

          //left
          topRight: isLeft ? cardRadius : Radius.zero,
        ),
      ),
    );

    Widget backColored = Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.only(
          //right
          bottomRight: isLeft ? Radius.zero : cardRadius,
          topLeft: isLeft ? Radius.zero : cardRadius,

          //left
          bottomLeft: isLeft ? cardRadius : Radius.zero,
          topRight: isLeft ? cardRadius : Radius.zero,
        ),
      ),
    );

    Widget child;
    if (isLeft) {
      child = Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            bottom: 0,
            child: cardColored,
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: backColored,
          ),
        ],
      );
    } else {
      child = Stack(
        children: <Widget>[
          Positioned(
            right: 0,
            bottom: 0,
            child: cardColored,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: backColored,
          ),
        ],
      );
    }

    return Container(
      height: 56,
      width: 56,
      child: child,
    );
  }
}
