//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:animator/animator.dart';

//widget
class TileHeader extends StatelessWidget {
  const TileHeader({
    @required this.isOpen,
    @required this.openOrClose,
    @required this.headerIcon,
    @required this.headerText,
    @required this.size,
    Key key,
  }) : super(key: key);

  final ValueNotifier<bool> isOpen;
  final Function openOrClose;
  final IconData headerIcon;
  final String headerText;
  final double size;

  @override
  Widget build(BuildContext context) {
    Color innerColor =  (isOpen.value)
    ? Theme.of(context).primaryColorDark
    : Colors.white;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(
        left: isOpen.value ? 0 : 12,
        right: isOpen.value ? 0 : 12,
        top: isOpen.value ? 0 : 8,
        bottom: isOpen.value ? 0 : 12,
      ),
      decoration: BoxDecoration(
        color: isOpen.value ? Theme.of(context).accentColor :  Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(
          Radius.circular(isOpen.value ? 0 : 12),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: openOrClose,
          child: Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 12.0,
                          ),
                          child: Icon(
                            headerIcon,
                            size: (size == null) ? 24 : size,
                            color: innerColor,
                          ),
                        ),
                        Text(
                          headerText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: innerColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: openOrClose,
                  icon: RotatingIcon(
                    color: innerColor,
                    isOpen: isOpen,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RotatingIcon extends StatelessWidget {
  RotatingIcon({
    @required this.color,
    this.duration: const Duration(milliseconds: 300),
    @required this.isOpen,
  });

  //passed params
  final Color color;
  final Duration duration;
  final ValueNotifier<bool> isOpen;

  //operating within
  final ValueNotifier<double> tweenBeginning = new ValueNotifier<double>(-1);
  final ValueNotifier<double> fractionOfDuration = new ValueNotifier<double>(1);

  //"constants"
  final double normalRotation = 0;
  final double otherRotation = (-math.pi / 4) * 4;

  @override
  Widget build(BuildContext context) {
    return Animator<double>(
      resetAnimationOnRebuild: true,
      tween: isOpen.value
        ? Tween<double>(
            begin: tweenBeginning.value == -1 ? normalRotation : tweenBeginning.value, 
            end: otherRotation,
        )
        : Tween<double>(
            begin: tweenBeginning.value == -1 ? otherRotation : tweenBeginning.value, 
            end: normalRotation,
        ),
      duration: Duration(
        milliseconds: ((duration.inMilliseconds * fractionOfDuration.value).toInt()),
      ),
      customListener: (animator) {
        tweenBeginning.value = animator.animation.value;
        fractionOfDuration.value = animator.controller.value;
      },
      builder: (anim) => Transform.rotate(
        angle: anim.value,
        child: Icon(
          Icons.keyboard_arrow_down,
          color: color,
        ),
      ),
    );
  }
}