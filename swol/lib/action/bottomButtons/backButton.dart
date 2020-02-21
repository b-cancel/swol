import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:swol/action/doneButton/corner.dart';
import 'package:swol/action/page.dart';
import 'package:swol/shared/widgets/simple/ourToolTip.dart';

class BottomBackButton extends StatelessWidget {
  const BottomBackButton({
    this.backAction,
    @required this.verticalPadding,
    @required this.color,
    Key key,
  }) : super(key: key);

  final Function backAction;
  final double verticalPadding;
  final Color color;

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
          child: Tooltip(
            message: ExcercisePage.pageNumber.value == 2 
            ? "going back won't reset the timer" 
            : "back",
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: backAction == null ? null : (){
                //notify users that the timer did not reset
                if(ExcercisePage.pageNumber.value == 2){
                  showToolTip(
                    context, 
                    "the timer won't reset",
                    showIcon: false,
                    direction: PreferDirection.bottomRight,
                  );
                }

                //go back
                //MUST HAPPEN AFTER so that pageNumber hasn't yet updated
                backAction();
              },
              child: Padding(
                padding: EdgeInsets.only(
                  top: 24,
                  bottom: 24,
                ),
                child: Stack(
                  children: <Widget>[
                    BottomRight(color: color),
                    ActualBackButton(
                      verticalPadding: verticalPadding,
                      hidden: backAction == null,
                    ),
                  ],
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
    Key key,
    @required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        color: Colors.transparent,
        height: 12,
        width: 12,
        child: FittedBox(
          fit: BoxFit.contain,
          child: ClipPath(
            clipper: CornerClipper(
              top: true,
              left: false,
            ),
            child: Container(
              color: color,
              height: 1,
              width: 1,
            ),
          ),
        ),
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