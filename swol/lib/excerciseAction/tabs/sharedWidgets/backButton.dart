import 'package:flutter/material.dart';

class BottomBackButton extends StatelessWidget {
  const BottomBackButton({
    this.backAction,
    @required this.verticalPadding,
    Key key,
  }) : super(key: key);

  final Function backAction;
  final double  verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
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
            (backAction == null) ? Container(
              width: 12,
            )
            : ActualBackButton(
              backAction: backAction, 
              verticalPadding: verticalPadding,
            ),
          ],
        ),
      ],
    );
  }
}

class ActualBackButton extends StatelessWidget {
  const ActualBackButton({
    Key key,
    @required this.backAction,
    @required this.verticalPadding,
  }) : super(key: key);

  final Function backAction;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => backAction(),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          top: verticalPadding,
          bottom: verticalPadding,
        ),
        child: Container(
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
      ),
    );
  }
}