import 'package:flutter/material.dart';

class BottomNextButton extends StatelessWidget {
  const BottomNextButton({
    Key key,
    @required this.forwardAction,
    @required this.forwardActionWidget,
    @required this.verticalPadding,
    @required this.excerciseID,
    @required this.wrapInHero,
  }) : super(key: key);

  final Function forwardAction;
  final Widget forwardActionWidget;
  final double verticalPadding;
  final int excerciseID;
  final bool wrapInHero;

  @override
  Widget build(BuildContext context) {
    Widget main =  RaisedButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      color: Theme.of(context).accentColor,
      onPressed: () => forwardAction(),
      padding: EdgeInsets.only(
        right: 16,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
        ),
        child: Opacity(
          opacity: wrapInHero ? 1 : 0,
          child: Row(
            children: <Widget>[
              Transform.translate(
                offset: Offset(0, 0),
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
    );

    if(wrapInHero){
      return Hero(
        tag: "excerciseContinue"+ excerciseID.toString(),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Material(
            color: Colors.transparent,
            child: main,
          ),
        ),
      );
    }
    else return main;
  }
}