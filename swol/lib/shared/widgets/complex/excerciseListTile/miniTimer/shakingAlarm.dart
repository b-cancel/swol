import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShakingAlarm extends StatelessWidget {
  ShakingAlarm({
    @required this.padding,
  });

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(padding),
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

//from: https://stackoverflow.com/questions/49374893/flutter-inverted-clipoval/49396544
class InvertedCircleClipper extends CustomClipper<Path> {
  InvertedCircleClipper({
    this.radiusPercent: 0.25,
  });

  final double radiusPercent;

  @override
  Path getClip(Size size) {
    return new Path()
      ..addOval(new Rect.fromCircle(
          center: new Offset(size.width / 2, size.height / 2),
          radius: size.width * radiusPercent))
      ..addRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}