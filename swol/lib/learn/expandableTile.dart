import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:scroll_to_index/scroll_to_index.dart';

class ExpandableTile extends StatefulWidget {
  const ExpandableTile({
    Key key,
    @required this.autoScrollController,
    @required this.index,
    @required this.isOpen,
    @required this.headerIcon,
    @required this.headerText,
    @required this.thisExpanded,
    this.size,
  }) : super(key: key);

  final AutoScrollController autoScrollController;
  final int index;
  final ValueNotifier<bool> isOpen;
  final IconData headerIcon;
  final String headerText;
  final Widget thisExpanded;
  final double size;

  @override
  _ExpandableTileState createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile> {
  @override
  Widget build(BuildContext context) {
    //Widget to switch between
    Widget _opened = Container(
      key: UniqueKey(),
      color: Theme.of(context).primaryColor,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(
        16,
      ),
      child: widget.thisExpanded,
    );

    Widget _closed = Container(
      key: UniqueKey(),
      height: 0,
      width: MediaQuery.of(context).size.width,
    );

    //eventhough it looks kinda ugly when no sections are open
    //not letting the user do this messes with usability
    openOrClose(){
      widget.isOpen.value = !widget.isOpen.value;
      setState(() {});
    }

    //build
    return AutoScrollTag(
      controller: widget.autoScrollController,
      key: ValueKey(widget.index),
      index: widget.index,
      child: SliverStickyHeader(
        header: AnimatedBuilder(
          animation: widget.isOpen,
          builder: (context, child){
            return Container(
              color: Theme.of(context).cardColor,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: openOrClose,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: (widget.isOpen.value) 
                          ? Theme.of(context).accentColor
                          : Colors.transparent,
                        ),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 22 + 8.0,
                                  child: Icon(
                                    widget.headerIcon,
                                    size: (widget.size == null) ? 24 : widget.size,
                                    color: (widget.isOpen.value)
                                    ? Theme.of(context).accentColor
                                    : Colors.white,
                                  ),
                                ),
                                Text(
                                  widget.headerText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: (widget.isOpen.value)
                                    ? Theme.of(context).accentColor
                                    : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: openOrClose,
                          icon: RotatingIcon(
                            isOpen: widget.isOpen,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        sliver: new SliverList(
          delegate: new SliverChildListDelegate([
            AnimatedBuilder(
              animation: widget.isOpen,
              builder: (context, child){
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (widget, animation){
                    return SizeTransition(
                      child: widget,
                      sizeFactor: Tween<double>(
                        begin: 0, 
                        end: 1,
                      ).animate(animation),
                    );
                  },
                  child: (widget.isOpen.value) ? _opened : _closed,
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}

class RotatingIcon extends StatefulWidget {
  RotatingIcon({
    this.duration: const Duration(milliseconds: 300),
    @required this.isOpen,
  });

  final Duration duration;
  final ValueNotifier<bool> isOpen;

  @override
  _RotatingIconState createState() => _RotatingIconState();
}

class _RotatingIconState extends State<RotatingIcon> {
  double tweenBeginning;
  double fractionOfDuration = 1;

  void translate() {
    widget.isOpen.addListener((){
      setState(() {
        
      });
    });
  }

  final double normalRotation = 0;
  final double otherRotation = (-math.pi / 4) * 4;

  @override
  Widget build(BuildContext context) {
    return Animator<double>(
      resetAnimationOnRebuild: true,
      tween: widget.isOpen.value
        ? Tween<double>(
            begin: tweenBeginning ?? normalRotation, 
            end: otherRotation,
        )
        : Tween<double>(
            begin: tweenBeginning ?? otherRotation, 
            end: normalRotation,
        ),
      duration: Duration(
        milliseconds: ((widget.duration.inMilliseconds * fractionOfDuration).toInt()),
      ),
      customListener: (animator) {
        tweenBeginning = animator.animation.value;
        fractionOfDuration = animator.controller.value;
      },
      builder: (anim) => Transform.rotate(
        angle: anim.value,
        child: Icon(
          Icons.keyboard_arrow_down,
          color: (widget.isOpen.value)
          ? Theme.of(context).accentColor
          : Colors.white,
        ),
      ),
    );
  }
}