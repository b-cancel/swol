import 'package:flutter/material.dart';

class BottomBackButton extends StatelessWidget {
  const BottomBackButton({
    this.backAction,
    @required this.verticalPadding,
    @required this.useAccentColor,
    Key key,
  }) : super(key: key);

  final Function backAction;
  final double  verticalPadding;
  final bool useAccentColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print("tappies");
        if(backAction != null) backAction();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                  ),
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
                    ActualBackButton(
                      verticalPadding: verticalPadding,
                      hidden: backAction == null,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 24,
            decoration: BoxDecoration(
              color: (useAccentColor ? Theme.of(context).accentColor :  Theme.of(context).cardColor),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
              ),
            ),
          )
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
        left: 16,
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