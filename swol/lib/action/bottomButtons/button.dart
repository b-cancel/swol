//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/action/bottomButtons/backButton.dart';
import 'package:swol/action/bottomButtons/nextButton.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//widget
class BottomButtons extends StatelessWidget {
  BottomButtons({
    @required this.excercise,
    @required this.forwardAction,
    @required this.forwardActionWidget,
    this.backAction,
  });

  final AnExcercise excercise;
  final Function forwardAction;
  final Widget forwardActionWidget;
  final Function backAction;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //fill the tiny gaps generate by flutter slightly flawed rendering
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
              ),
            )
          ),
        ),
        //the buttons that are larger than they seem to be
        Buttons(
          excercise: excercise,
          forwardAction: forwardAction,
          forwardActionWidget: forwardActionWidget,
          backAction: backAction,
          useAccentColor: true,
        ),
      ],
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({
    @required this.excercise,
    @required this.forwardAction,
    @required this.forwardActionWidget,
    this.backAction,
    this.useAccentColor,
  });

  final AnExcercise excercise;
  final Function forwardAction;
  final Widget forwardActionWidget;
  final Function backAction;
  final bool useAccentColor;

  @override
  Widget build(BuildContext context) {
    double extraVerticalPadding = 8;
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            //TODO: should also probably pass something that links to the next buttons activity
            //because this is the back button but it also hold a peice of the next button
            //that ofcourse will change colors when PROPERLY active
            child: BottomBackButton( 
              backAction: backAction,
              verticalPadding: extraVerticalPadding,
              useAccentColor: useAccentColor,
            ),
          ),
          BottomNextButton(
            forwardAction: forwardAction, 
            forwardActionWidget: forwardActionWidget,
            verticalPadding: extraVerticalPadding,
            excercise: excercise,
          ),
        ],
      ),
    );
  }
}