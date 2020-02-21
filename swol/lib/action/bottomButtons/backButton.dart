//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:bot_toast/bot_toast.dart';

//internal
import 'package:swol/shared/widgets/simple/curvedCorner.dart';
import 'package:swol/shared/widgets/simple/ourToolTip.dart';
import 'package:swol/action/page.dart';

//build
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