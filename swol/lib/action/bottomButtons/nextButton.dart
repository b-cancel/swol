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
  }) : super(key: key);

  final Function forwardAction;
  final Widget forwardActionWidget;
  final double verticalPadding;
  final AnExcercise excercise;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => forwardAction(),
      child: Padding(
        padding: EdgeInsets.only(
          top: 24,
          bottom: 24,
        ),
        child: Container(
          //NOTE: this container is only just a wrapper to the animated container
          //a place holder for when the hero is playing
          //and the hero will only be playing if the button has the accent color
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          //this is the actuall button with stuff in it
          child: Hero(
            tag: "excerciseContinue" + excercise.id.toString(),
            createRectTween: (begin, end) {
              return CustomRectTween(a: begin, b: end);
            },
            child: FittedBox(
              fit: BoxFit.contain,
              child: Material(
                color: Colors.transparent,
                child: Container(
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
                    child: Row(
                      children: <Widget>[
                        Transform.translate(
                          offset: Offset(0, 0),
                          child: Icon(
                            Icons.arrow_drop_down,
                          ),
                        ),
                        forwardActionWidget,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
