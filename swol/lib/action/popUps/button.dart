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
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: Material(
        color: clear ? Colors.transparent : Theme.of(context).accentColor,
        child: InkWell(
          onTap: () => onTap(),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 8,
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                color: clear ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
