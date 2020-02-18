import 'package:flutter/material.dart';

class AwesomeButton extends StatelessWidget {
  AwesomeButton({
    @required this.child,
    @required this.onTap,
    this.clear: false,
  });

  final Widget child;
  final Function onTap;
  final bool clear;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: clear ? Colors.transparent : Theme.of(context).accentColor,
      child: InkWell(
        onTap: () => onTap(),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: clear ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
