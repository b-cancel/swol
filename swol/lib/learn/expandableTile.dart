//flutter
import 'package:flutter/material.dart';

//dart
import 'dart:math' as math;

//plugins
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:animator/animator.dart';
import 'package:shimmer/shimmer.dart';

//NOTE: the left indent inside of a drop down doesn't look right

class ExpandableTile extends StatefulWidget {
  const ExpandableTile({
    Key key,
    @required this.autoScrollController,
    @required this.index,
    @required this.isOpen,
    @required this.headerIcon,
    @required this.headerText,
    @required this.expandedChild,
    this.theOnlyException: true,
    this.size,
  }) : super(key: key);

  final AutoScrollController autoScrollController;
  final int index;
  final ValueNotifier<bool> isOpen;
  final IconData headerIcon;
  final String headerText;
  final Widget expandedChild;
  final double size;
  final bool theOnlyException;
  //style options

  @override
  _ExpandableTileState createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile> {
  @override
  Widget build(BuildContext context) {
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
            return TileHeader(
              headerIcon: widget.headerIcon,
              headerText: widget.headerText,
              size: widget.size,
              openOrClose: () => openOrClose(),
              isOpen: widget.isOpen,
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
                  child: (widget.isOpen.value) 
                  ? TileOpened(
                    child: widget.expandedChild,
                    theOnlyException: widget.theOnlyException,
                  )
                  : Container(
                    key: UniqueKey(),
                    height: 0,
                    width: MediaQuery.of(context).size.width,
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}

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
                        Container(
                          alignment: Alignment.centerLeft,
                          width: 22 + 8.0,
                          child: Icon(
                            headerIcon,
                            size: (size == null) ? 24 : size,
                            color: (isOpen.value)
                            ? Theme.of(context).primaryColorDark
                            : Colors.white,
                          ),
                        ),
                        Text(
                          headerText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: (isOpen.value)
                            ? Theme.of(context).primaryColorDark
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

class TileOpened extends StatelessWidget {
  const TileOpened({
    @required this.child,
    @required this.theOnlyException,
    Key key,
  }) : super(key: key);

  final Widget child;
  final bool theOnlyException;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned.fill(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                key: UniqueKey(),
                color: Theme.of(context).cardColor,
                padding: EdgeInsets.only(
                  bottom: 24,
                ),
                child: child,
              ),
            ),
          ],
        ),
        Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                color: theOnlyException ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
              ),
            ),
            Container(
              height: 128,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.0),
                  bottomRight:  Radius.circular(12.0),
                ),
                color: Theme.of(context).primaryColorDark,
              ),
              child: Center(
                child: Shimmer.fromColors(
                  direction: ShimmerDirection.ltr,
                  baseColor: Theme.of(context).primaryColor,
                  highlightColor: Theme.of(context).cardColor,
                  child: Icon(
                    MaterialCommunityIcons.getIconData("chevron-double-down"),
                    size: 36,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
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
          ? Theme.of(context).primaryColorDark
          : Colors.white,
        ),
      ),
    );
  }
}