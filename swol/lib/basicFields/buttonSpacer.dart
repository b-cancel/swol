import 'package:flutter/material.dart';

class OneOrTwoButtons extends StatelessWidget {
  OneOrTwoButtons({
    @required this.backgroundColor,
    @required this.top,
    @required this.twoButtons,
    @required this.bottom,
  });

  final Color backgroundColor;
  final Widget top;
  final bool twoButtons;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        color: backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            top,
            (twoButtons == false) ? Container() 
            : _ButtonSpacer(),
            bottom,
          ],
        ),
      ),
    );
  }
}

class _ButtonSpacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Container(
        color: Theme.of(context).primaryColorDark,
        height: 2,
        child: Container(),
      ),
    );
  }
}