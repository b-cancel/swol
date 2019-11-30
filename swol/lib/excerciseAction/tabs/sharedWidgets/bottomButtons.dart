import 'package:flutter/material.dart';

class BottomButtons extends StatelessWidget {
  BottomButtons({
    this.allSetsComplete,
    @required this.forwardAction,
    @required this.forwardActionWidget,
    this.backAction,
    this.flipped: false,
  });

  final Function allSetsComplete;
  final Function forwardAction;
  final Widget forwardActionWidget;
  final Function backAction;
  final bool flipped;

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
            useRaisedButton: flipped,
          ),
          Expanded(
            child: Container(),
          ),
          backAction == null ? Container() : FlatButton(
            onPressed: () => backAction(),
            child: Text("Back"),
          ),
          (flipped) 
          ? OutlineButton(
            highlightedBorderColor: Theme.of(context).accentColor,
            onPressed: () => allSetsComplete(),
            child: forwardActionWidget,
          )
          : RaisedButton(
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
    this.useRaisedButton: false,
    Key key,
  }) : super(key: key);

  final int setCount;
  final Function allSetsComplete;
  final bool useRaisedButton;

  @override
  Widget build(BuildContext context) {
    Widget buttonContent = RichText(
      text: TextSpan(
        style: TextStyle(
          color: useRaisedButton ? Theme.of(context).primaryColorDark : Colors.white,
        ),
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
    );

    if(useRaisedButton){
      return RaisedButton(
        color: Theme.of(context).accentColor,
        onPressed: () => allSetsComplete(),
        child: buttonContent,
      );
    }
    else{
      return OutlineButton(
        highlightedBorderColor: Theme.of(context).accentColor,
        onPressed: () => allSetsComplete(),
        child: buttonContent,
      );
    }
  }
}