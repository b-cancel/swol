import 'package:flutter/material.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/widgets/simple/heros/curveMod.dart';

class BottomNextButton extends StatelessWidget {
  const BottomNextButton({
    Key key,
    @required this.forwardAction,
    @required this.forwardActionWidget,
    @required this.verticalPadding,
    @required this.excercise,
    @required this.wrapInHero,
  }) : super(key: key);

  final Function forwardAction;
  final Widget forwardActionWidget;
  final double verticalPadding;
  final AnExcercise excercise;
  final bool wrapInHero;

  @override
  Widget build(BuildContext context) {
    Widget main = Container(
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
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
                  //color: Theme.of(context).primaryColorDark,
                ),
              ),
              forwardActionWidget,
            ],
          ),
        ),
      ),
    );

    main = GestureDetector(
      onTap: () => forwardAction(),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            main,
            Container(
              height: 24,
              color: Theme.of(context).accentColor,
            )
          ]
        ),
      ),
    );

    if(wrapInHero){
      return Hero(
        tag: "excerciseContinue"+ excercise.id.toString(),
        createRectTween: (begin, end) {
          return CustomRectTween(a: begin, b: end);
        },
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