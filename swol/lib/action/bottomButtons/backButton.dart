import 'package:flutter/material.dart';

class BottomBackButton extends StatelessWidget {
  const BottomBackButton({
    this.backAction,
    @required this.verticalPadding,
    @required this.useAccentColor,
    Key key,
  }) : super(key: key);

  final Function backAction;
  final double verticalPadding;
  final bool useAccentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        //the section that the "finish with this excercise"
        //button might be at
        Expanded(
          child: Container(),
        ),
        //the button that looks small but is actually very tall
        Container(
          child: GestureDetector(
            onTap: backAction == null ? null : () => backAction(),
            child: Padding(
              padding: EdgeInsets.only(
                top: 24,
                bottom: 24,
              ),
              child: Stack(
                children: <Widget>[
                  BottomRightCorner(),
                  ActualBackButton(
                    verticalPadding: verticalPadding,
                    hidden: backAction == null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BottomRightCorner extends StatelessWidget {
  const BottomRightCorner({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              color: Theme.of(context).accentColor,
              height: 12,
              width: 12,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(12),
              ),
            ),
            height: 24,
            width: 24,
          ),
        ],
      ),
    );
  }
}

class ActualBackButton extends StatelessWidget {
  const ActualBackButton({
    Key key,
    @required this.verticalPadding,
    @required this.hidden,
  }) : super(key: key);

  final double verticalPadding;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24, //extra spacing for big fingers
        top: verticalPadding,
        bottom: verticalPadding,
      ),
      child: Opacity(
        opacity: hidden ? 0 : 1,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Back",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Icon(Icons.arrow_drop_up),
          ],
        ),
      ),
    );
  }
}
