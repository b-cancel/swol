import 'package:flutter/material.dart';

class BottomButtons extends StatelessWidget {
  BottomButtons({
    this.allSetsComplete,
    @required this.forwardAction,
    @required this.forwardActionWidget,
    this.backAction,
  });

  final Function allSetsComplete;
  final Function forwardAction;
  final Widget forwardActionWidget;
  final Function backAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          allSetsComplete == null ? Container() : DoneButton(
            allSetsComplete: allSetsComplete,
          ),
          Expanded(
            child: Container(),
          ),
          backAction == null ? Container() : FlatButton(
            onPressed: () => backAction(),
            child: Text("Back"),
          ),
          RaisedButton(
            color: Theme.of(context).accentColor,
            onPressed: () => forwardAction(),
            child: forwardActionWidget,
          )
        ],
      ),
    );
  }
}

class DoneButton extends StatelessWidget {
  const DoneButton({
    //TODO: ofcourse use the actual set count given my diagram
    this.setCount: 3, //TODO: perhaps use excercise ID instead
    @required this.allSetsComplete,
    Key key,
  }) : super(key: key);

  final int setCount;
  final Function allSetsComplete;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      highlightedBorderColor: Theme.of(context).accentColor,
      onPressed: () => allSetsComplete(),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: setCount.toString() + " Sets",
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            TextSpan(
              text: " Complete",
              style: TextStyle(
              ),
            ),
          ],
        ),
      ),
    );
  }
}