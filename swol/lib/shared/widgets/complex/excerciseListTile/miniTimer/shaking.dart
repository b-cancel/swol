import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/shared/widgets/complex/excerciseListTile/miniTimer/invertedCircleClipper.dart';

class ShakingAlarm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Transform.translate(
                offset: Offset(0, -1.20),
                child: new ClipPath(
                  clipper: new InvertedCircleClipper(),
                  child: Image(
                    image: new AssetImage("assets/alarm.gif"),
                    //lines being slightly distinguishable is ugly
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Icon(
                  FontAwesomeIcons.times,
                  color: Theme.of(context).cardColor,
                  size: 14,
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimerShaker extends StatelessWidget {
  const TimerShaker({
    Key key,
    @required this.controller,
    @required this.noTimeLeft,
  }) : super(key: key);

  final AnimationController controller;
  final bool noTimeLeft;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Visibility(
        visible: controller.value != 1,
        child: Transform.translate(
          offset: Offset(0, -4),
          child: Container(
            alignment: Alignment.topCenter,
            child: Container(
              width: 14,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Container(
                  //NOTE: width and height are placeholders to avoid an error
                  width: 50,
                  height: 50,
                  child: Image(
                  image: new AssetImage(
                    (noTimeLeft == false) ? "assets/alarmTick.gif" : "assets/tickStill.png",
                  ),
                  color: Colors.white,
                ),
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}