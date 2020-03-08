//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/simple/heros/curveMod.dart';

//widget
class BottomNextButton extends StatelessWidget {
  const BottomNextButton({
    Key key,
    @required this.color,
    @required this.forwardAction,
    @required this.forwardActionWidget,
    @required this.verticalPadding,
    @required this.exerciseID,
  }) : super(key: key);

  final Color color;
  final Function forwardAction;
  final Widget forwardActionWidget;
  final double verticalPadding;
  final int exerciseID;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
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
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          //this is the actuall button with stuff in it
          child: Hero(
            tag: "exerciseContinue" + exerciseID.toString(),
            createRectTween: (begin, end) {
              return CustomRectTween(a: begin, b: end);
            },
            child: FittedBox(
              fit: BoxFit.contain,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
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
