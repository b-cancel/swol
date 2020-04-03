//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:animator/animator.dart';
import 'package:swol/action/page.dart';

//internal
import 'package:swol/shared/widgets/simple/curvedCorner.dart';

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
      duration: ExercisePage.transitionDuration,
      margin: EdgeInsets.only(
        left: isOpen.value ? 0 : 12,
        right: isOpen.value ? 0 : 12,
        top: isOpen.value ? 0 : 8,
        bottom: isOpen.value ? 0 : 12,
      ),
      decoration: BoxDecoration(
        color: isOpen.value ? Theme.of(context).accentColor :  Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isOpen.value ? 0 : 12),
          topRight: Radius.circular(isOpen.value ? 0 : 12),
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Visibility(
              visible: true,
              child: AnimatedContainer(
                duration: ExercisePage.transitionDuration,
                width: MediaQuery.of(context).size.width,
                child: Transform.translate(
                  offset: Offset(
                    0, 
                    //size of curve, size of other curve
                    isOpen.value ? 24 : -6, //to hide given other curves
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: ClipPath(
                            clipper: CornerClipper(
                              isTop: true,
                              isLeft: true,
                            ),
                            child: AnimatedContainer(
                              duration: ExercisePage.transitionDuration,
                              //color switch to match button
                              decoration: new BoxDecoration(
                                color: isOpen.value ? Theme.of(context).accentColor : Theme.of(context).cardColor,
                              ),
                              //this is what primarily animates
                              height: 1,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: ClipPath(
                            clipper: CornerClipper(
                              isTop: true,
                              isLeft: false,
                            ),
                            child: AnimatedContainer(
                              duration: ExercisePage.transitionDuration,
                              //color switch to match button
                              decoration: new BoxDecoration(
                                color: isOpen.value ? Theme.of(context).accentColor : Theme.of(context).cardColor,
                              ),
                              //this is what primarily animates
                              height: 1,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ),
          Material(
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
        ],
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