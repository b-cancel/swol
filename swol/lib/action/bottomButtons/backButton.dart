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
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Container(
                height: 24,
                padding: EdgeInsets.only(
                  top: 24,
                ),
                decoration: BoxDecoration(
                  color: (useAccentColor
                      ? Theme.of(context).accentColor
                      : Theme.of(context).cardColor),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                  ),
                ),
              ),
            ],
          ),
        ),
        //the button that looks small but is actually very tall
        GestureDetector(
          onTap: backAction == null ? null : () => backAction(),
          child: Padding(
            padding: EdgeInsets.only(
              top: 24,
            ),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    children: <Widget>[
                      Positioned(
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
                      ),
                      ActualBackButton(
                        verticalPadding: verticalPadding,
                        hidden: backAction == null,
                      ),
                    ],
                  ),
                  Container(
                    height: 24,
                    color: (useAccentColor ? Theme.of(context).accentColor : Theme.of(context).cardColor),
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
            Transform.translate(
              offset: Offset(0, 0),
              child: Icon(Icons.arrow_drop_up),
            ),
          ],
        ),
      ),
    );
  }
}
