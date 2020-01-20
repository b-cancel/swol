//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/excerciseAction/tabs/sharedWidgets/backButton.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/nextButton.dart';

//TODO: the next button should not light up until you have met the requirements
//sometimes these are automatically met
//sometimes not so much
//in this case another function should run
//TODO: the function might also vary... 
//1. since trying to go the next set before the timer ends 
//2. should perhaps trigger different that doing so after it ends
//3. and similarly after it mega ends
class BottomButtons extends StatelessWidget {
  BottomButtons({
    @required this.forwardAction,
    @required this.forwardActionWidget,
    this.backAction,
  });

  final Function forwardAction;
  final Widget forwardActionWidget;
  final Function backAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Buttons(
          forwardAction: forwardAction,
          forwardActionWidget: forwardActionWidget,
          backAction: backAction,
        ),
        CardTop(
          useAccentColor: (backAction == null),
        )
      ],
    );
  }
}

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

class Buttons extends StatelessWidget {
  const Buttons({
    @required this.forwardAction,
    @required this.forwardActionWidget,
    this.backAction,
  });

  final Function forwardAction;
  final Widget forwardActionWidget;
  final Function backAction;

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
            ),
          ),
          BottomNextButton(
            forwardAction: forwardAction, 
            forwardActionWidget: forwardActionWidget,
            verticalPadding: extraVerticalPadding,
          ),
        ],
      ),
    );
  }
}