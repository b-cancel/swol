import 'package:flutter/material.dart';

class TextWithCorners extends StatelessWidget {
  const TextWithCorners({
    Key key,
    @required this.text,
    @required this.radius,
  }) : super(key: key);

  final String text;
  final Radius radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: Corner(
            cardRadius: radius,
            isLeft: true,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Corner(
            cardRadius: radius,
          ),
        ),
      ],
    );
  }
}

class Corner extends StatelessWidget {
  const Corner({
    Key key,
    @required this.cardRadius,
    this.isLeft: false,
  }) : super(key: key);

  final Radius cardRadius;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    Widget cardColored = Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
        color: Theme.of(context).primaryColorDark,
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
    if(isLeft){
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
    }
    else{
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