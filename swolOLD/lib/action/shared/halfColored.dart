import 'package:flutter/material.dart';

class TopBackgroundColored extends StatelessWidget {
  TopBackgroundColored({
    @required this.child,
    @required this.color,
  });

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  color: color,
                ),
              ),
              Expanded(child: Container()),
            ]
          ),
        ),
        child,
      ],
    );
  }
}