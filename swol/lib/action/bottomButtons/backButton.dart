//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:bot_toast/bot_toast.dart';
import 'package:swol/shared/widgets/simple/conditional.dart';

//internal
import 'package:swol/shared/widgets/simple/curvedCorner.dart';
import 'package:swol/shared/widgets/simple/ourToolTip.dart';
import 'package:swol/action/page.dart';

//build
class BottomBackButton extends StatefulWidget {
  const BottomBackButton({
    this.backAction,
    required this.verticalPadding,
    required this.color,
    Key? key,
  }) : super(key: key);

  final Function? backAction;
  final double verticalPadding;
  final Color color;

  @override
  _BottomBackButtonState createState() => _BottomBackButtonState();
}

class _BottomBackButtonState extends State<BottomBackButton> {
  updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    ExercisePage.pageNumber.addListener(updateState);
  }

  @override
  void dispose() {
    ExercisePage.pageNumber.removeListener(updateState);
    super.dispose();
  }

  String backToWhere() {
    if (ExercisePage.pageNumber.value == 2) {
      return "going back won't reset the timer";
    } else {
      //could only be page 1, page 0 has no back button
      return "back to your sugggestion";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        //the button that looks small but is actually very tall
        Conditional(
          //only happens on the first page
          condition: (widget.backAction == null),
          //just the curve so the next button looks whole
          //NOTE: doesnt care about done button height
          ifTrue: Padding(
            padding: EdgeInsets.only(
              bottom: 24,
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  width: 12,
                  height: 12,
                ),
                BottomRight(
                  color: widget.color,
                ),
              ],
            ),
          ),
          //actualy the bottom button
          ifFalse: Tooltip(
            message: backToWhere(),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                //notify users that the timer did not reset
                if (ExercisePage.pageNumber.value == 2) {
                  showToolTip(
                    context,
                    "the timer won't reset",
                    showIcon: false,
                    direction: PreferDirection.bottomRight,
                  );
                } else {
                  if (ExercisePage.pageNumber.value == 1) {
                    showToolTip(
                      context,
                      "the timer won't reset, as long as your set is valid",
                      showIcon: false,
                      direction: PreferDirection.bottomRight,
                    );
                  }
                }

                //go back
                //MUST HAPPEN AFTER so that pageNumber hasn't yet updated
                widget.backAction!();
              },
              child: Container(
                padding: EdgeInsets.only(
                  top: ExercisePage.mainButtonsHeight,
                  bottom: 24,
                ),
                child: Container(
                  height: ExercisePage.mainButtonsHeight,
                  child: Stack(
                    children: <Widget>[
                      BottomRight(
                        color: widget.color,
                      ),
                      ActualBackButton(
                        verticalPadding: widget.verticalPadding,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BottomRight extends StatelessWidget {
  const BottomRight({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: CurvedCorner(
        size: 12,
        isTop: false,
        isLeft: false,
        cornerColor: color,
      ),
    );
  }
}

class ActualBackButton extends StatelessWidget {
  const ActualBackButton({
    Key? key,
    required this.verticalPadding,
  }) : super(key: key);

  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24, //extra spacing for big fingers
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Text(
                "Back",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_up),
          ],
        ),
      ),
    );
  }
}
