//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/action/bottomButtons/backButton.dart';
import 'package:swol/action/bottomButtons/nextButton.dart';
import 'package:swol/shared/methods/theme.dart';

//widget
class BottomButtons extends StatelessWidget {
  BottomButtons({
    @required this.color,
    @required this.exerciseID,
    @required this.forwardAction,
    @required this.forwardActionWidget,
    this.backAction,
  });

  final Color color;
  final int exerciseID;
  final Function forwardAction;
  final Widget forwardActionWidget;
  final Function backAction;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MyTheme.dark,
      child: Stack(
        children: <Widget>[
          //fill the tiny gaps generate by flutter slightly flawed rendering
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 24,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                ),
              )
            ),
          ),
          //the buttons that are larger than they seem to be
          Buttons(
            exerciseID: exerciseID,
            forwardAction: forwardAction,
            forwardActionWidget: forwardActionWidget,
            backAction: backAction,
            color: color,
          ),
        ],
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({
    @required this.exerciseID,
    @required this.forwardAction,
    @required this.forwardActionWidget,
    this.backAction,
    this.color,
  });

  final int exerciseID;
  final Function forwardAction;
  final Widget forwardActionWidget;
  final Function backAction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    double extraVerticalPadding = 8;
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: BottomBackButton( 
              backAction: backAction,
              verticalPadding: extraVerticalPadding,
              color: color,
            ),
          ),
          BottomNextButton(
            forwardAction: forwardAction, 
            forwardActionWidget: forwardActionWidget,
            verticalPadding: extraVerticalPadding,
            exerciseID: exerciseID,
            color: color,
          ),
        ],
      ),
    );
  }
}