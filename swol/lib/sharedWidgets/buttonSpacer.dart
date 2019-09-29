import 'package:flutter/material.dart';

class ButtonSpacer extends StatelessWidget {
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