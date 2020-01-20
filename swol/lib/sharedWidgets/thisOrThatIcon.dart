import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ThisOrThatIcon extends StatelessWidget {
  const ThisOrThatIcon({
    @required this.one,
    @required this.other,
    this.backgroundColor,
    this.iconColor,
    Key key,
  }) : super(key: key);

  final Widget one;
  final Widget other;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    double size = 16;

    Color backgroundC = (backgroundColor == null) ? Theme.of(context).cardColor : backgroundColor;
    Color iconC = (iconColor == null) ? Colors.white.withOpacity(0.75) : iconColor;

    return Container(
      height: size,
      width: size,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Icon(
                FontAwesomeIcons.percentage,
                color: iconC,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: size/2,
              width: size/2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                    ),
                    child: ClipOval(
                      child: Container(
                        color: backgroundC,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: one,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: size/2,
              width: size/2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 4.0,
                    ),
                    child: ClipOval(
                      child: Container(
                        color: backgroundC,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: other,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}