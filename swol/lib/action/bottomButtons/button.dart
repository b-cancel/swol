//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/action/bottomButtons/backButton.dart';
import 'package:swol/action/bottomButtons/nextButton.dart';
import 'package:swol/action/page.dart';
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
      child: Container(
        //card top + bottom buttons + done button height
        height: 24 + (ExercisePage.mainButtonsHeight * 2),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 24,
                width: MediaQuery.of(context).size.width,
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
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        BottomBackButton( 
          backAction: backAction,
          verticalPadding: extraVerticalPadding,
          color: color,
        ),
        BottomNextButton(
          forwardAction: forwardAction, 
          forwardActionWidget: forwardActionWidget,
          exerciseID: exerciseID,
          color: color,
        ),
      ],
    );
  }
}