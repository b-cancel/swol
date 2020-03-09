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
    return Padding(
      padding: EdgeInsets.only(
        bottom: 8.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
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
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
