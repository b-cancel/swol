import 'package:flutter/material.dart';

class ScrollViewWithShadow extends StatefulWidget {
  ScrollViewWithShadow({
    required this.child,
    this.transparentWhite: true,
  });

  final Widget child;
  final bool transparentWhite;

  @override
  _ScrollViewWithShadowState createState() => _ScrollViewWithShadowState();
}

class _ScrollViewWithShadowState extends State<ScrollViewWithShadow> {
  final ScrollController ctrl = new ScrollController();
  final ValueNotifier<bool> onTop = new ValueNotifier<bool>(false);
  final ValueNotifier<bool> onBottom = new ValueNotifier<bool>(false);

  scrollUpdate() {
    ScrollPosition position = ctrl.position;
    double currentOffset = ctrl.offset;
    onTop.value = (currentOffset <= position.minScrollExtent);
    onBottom.value = (currentOffset >= position.maxScrollExtent);
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      scrollUpdate();
    });
    ctrl.addListener(scrollUpdate);
    super.initState();
  }

  @override
  void dispose() {
    ctrl.removeListener(scrollUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          controller: ctrl,
          child: widget.child,
        ),
        ScrollShadow(
          active: onTop,
          isTop: true,
          transparentWhite: widget.transparentWhite,
        ),
        ScrollShadow(
          active: onBottom,
          isTop: false,
          transparentWhite: widget.transparentWhite,
        ),
      ],
    );
  }
}

//just the shadow that appears
class ScrollShadow extends StatefulWidget {
  ScrollShadow({
    required this.active,
    required this.isTop,
    required this.transparentWhite,
  });

  final ValueNotifier<bool> active;
  final bool isTop;
  final bool transparentWhite;

  @override
  _ScrollShadowState createState() => _ScrollShadowState();
}

class _ScrollShadowState extends State<ScrollShadow> {
  updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    widget.active.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() {
    widget.active.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color middle = (widget.transparentWhite) ? Colors.white : Colors.black;
    middle = middle.withOpacity(0);
    Color edge = Colors.black;

    //create shadow
    Widget theShadow = Visibility(
      visible: widget.active.value == false,
      child: Container(
        height: 24,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              widget.isTop ? edge : middle,
              widget.isTop ? middle : edge,
            ],
            stops: [0, 1],
          ),
        ),
      ),
    );

    //position
    if (widget.isTop) {
      return Positioned(
        top: 0,
        child: theShadow,
      );
    } else {
      return Positioned(
        bottom: 0,
        child: theShadow,
      );
    }
  }
}

//padding in all directions
class BottomButtonsThatResizeTRBL extends StatelessWidget {
  const BottomButtonsThatResizeTRBL({
    Key? key,
    required this.secondary,
    required this.primary,
    this.hasTopIcon: true,
  }) : super(key: key);

  final Widget secondary;
  final Widget primary;
  final bool hasTopIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16.0,
        bottom: hasTopIcon ? 0 : 8,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.bottomRight,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              secondary,
              Theme(
                data: Theme.of(context).copyWith(
                  buttonTheme: ButtonThemeData(
                    textTheme: ButtonTextTheme.primary,
                    buttonColor: Theme.of(context).accentColor,
                  ),
                ),
                child: primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//padding all directions
class TitleThatContainsTRBL extends StatelessWidget {
  const TitleThatContainsTRBL({
    Key? key,
    required this.child,
    this.hasTopIcon: true,
  }) : super(key: key);

  final Widget child;
  final bool hasTopIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: hasTopIcon ? 0 : 16,
        bottom: 24,
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Container(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
