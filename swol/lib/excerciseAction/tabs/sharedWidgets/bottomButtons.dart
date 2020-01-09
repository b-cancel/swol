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
    /*
    DoneButton(
                        allSetsComplete: allSetsComplete,
                        useRaisedButton: flipped,
                      ),
    */

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Buttons(
          forwardAction: forwardAction,
          forwardActionWidget: forwardActionWidget,
        ),
        CardPeek()
      ],
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({
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
    return Container(
      color: Theme.of(context).primaryColorDark,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: BottomLeftCurve(
              otherColor: Theme.of(context).accentColor,
              backgroundColor: Theme.of(context).primaryColorDark,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: RaisedButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(0.0),
                ),
                color: Theme.of(context).accentColor,
                onPressed: () => forwardAction(),
                padding: EdgeInsets.only(
                  right: 8,
                ),
                child: Row(
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(0, 3),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    forwardActionWidget,
                  ],
                ),
              ),
            ),
            /*
            width: 128,
            child: Container(
              //curve + height of button
              height: (other ? 24 : 12) + 24.0,
            ),
            */
            
            /*InkWell(
              onTap: () => forwardAction(),
              child: forwardActionWidget,
            ),
            */
          ),
          
          /*
          allSetsComplete == null ? Container() : 
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
          ),
          */
        ],
      ),
    );
  }
}

class BottomLeftCurve extends StatelessWidget {
  const BottomLeftCurve({
    @required this.backgroundColor,
    @required this.otherColor,
    Key key,
  }) : super(key: key);

  final Color backgroundColor;
  final Color otherColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              color: otherColor,
              height: 36,
            ),
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(12),
                ),
              ),
              height: 36,
            ),
          ],
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 4.0,
                left: 16,
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    "Back",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -3),
                    child: Icon(Icons.arrow_drop_up),
                  ),
                ],
              ),
            ),
          )
          
          /*
          Container(
            child: Text(
              "hi",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          */
        ),
      ],
    );
  }
}

class CardPeek extends StatelessWidget {
  const CardPeek({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
        ),
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
    Widget buttonContent = Row(
      children: <Widget>[
        Icon(Icons.arrow_left),
        RichText(
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
        ),
      ],
    );

    if(useRaisedButton){
      return RaisedButton(
        color: Theme.of(context).accentColor,
        onPressed: () => allSetsComplete(),
        child: buttonContent,
      );
    }
    else{
      return Opacity(
        opacity: (allSetsComplete == null) ? 0 : 1.0,
        child: OutlineButton(
          highlightedBorderColor: Theme.of(context).accentColor,
          onPressed: allSetsComplete == null ? null : () => allSetsComplete(),
          child: buttonContent,
        ),
      );
    }
  }
}