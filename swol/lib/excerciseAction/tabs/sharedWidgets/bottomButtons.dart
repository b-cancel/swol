//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/excerciseAction/tabs/sharedWidgets/backButton.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/nextButton.dart';
import 'package:swol/shared/structs/anExcercise.dart';
//TODO: at all times the next button should hero with the excercise tile's "next?" button
//TODO: ofcourse if the "next?" button is in the excercise tile

//TODO: from suggest page
//1. if we are BEFORE our set target then highlight
//2. if we are AFTER our set target then we don't highlight
//TODO: make sure the above also according affects the next page

//TODO: from set record page
//we don't care if we are BEFORE or AFTER our set target
//either way the user has decided to continue
//we should respect that
//and there are no other bottom buttons to click or distract
//so we simply highligt the bottom next button at all times

//TODO: from break duration page
//same as suggest page, except that we don't care about how it affectsthe next page
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
    return Buttons(
      excercise: excercise,
      forwardAction: forwardAction,
      forwardActionWidget: forwardActionWidget,
      backAction: backAction,
      useAccentColor: true,
    );
  }
}

/*
class CardTop extends StatelessWidget {
  const CardTop({
    @required this.useAccentColor,
    Key key,
  }) : super(key: key);
  
  final bool useAccentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: (useAccentColor ? Theme.of(context).accentColor :  Theme.of(context).cardColor),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
        ),
      ),
    );
  }
}
*/

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
          /*
          BottomNextButton(
                forwardAction: forwardAction, 
                forwardActionWidget: forwardActionWidget,
                verticalPadding: extraVerticalPadding,
                excercise: excercise,
                wrapInHero: false,
              ),
          */
          BottomNextButton(
            forwardAction: forwardAction, 
            forwardActionWidget: forwardActionWidget,
            verticalPadding: extraVerticalPadding,
            excercise: excercise,
            wrapInHero: true,
          ),
        ],
      ),
    );
  }
}