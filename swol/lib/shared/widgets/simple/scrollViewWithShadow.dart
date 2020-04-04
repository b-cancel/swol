import 'package:flutter/material.dart';

class ScrollViewWithShadow extends StatefulWidget {
  ScrollViewWithShadow({
    @required this.child,
  });

  final Widget child;

  @override
  _ScrollViewWithShadowState createState() => _ScrollViewWithShadowState();
}

class _ScrollViewWithShadowState extends State<ScrollViewWithShadow> {
  final ScrollController ctrl = new ScrollController();
  final ValueNotifier<bool> onTop = new ValueNotifier<bool>(true);
  final ValueNotifier<bool> onBottom = new ValueNotifier<bool>(false);

  scrollUpdate(){
    ScrollPosition position = ctrl.position;
    double currentOffset = ctrl.offset;
    onTop.value = (currentOffset <= position.minScrollExtent);
    onBottom.value = (currentOffset >= position.maxScrollExtent);
  }

  @override
  void initState() {
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
        ),
        ScrollShadow(
          active: onBottom, 
          isTop: false,
        ),
      ],
    );
  }
}

class ScrollShadow extends StatefulWidget {
  ScrollShadow({
    @required this.active,
    @required this.isTop,
  });

  final ValueNotifier<bool> active;
  final bool isTop;

  @override
  _ScrollShadowState createState() => _ScrollShadowState();
}

class _ScrollShadowState extends State<ScrollShadow> {
  updateState(){
    if(mounted){
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
    Color middle = Colors.white.withOpacity(0);
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
    if(widget.isTop){
      return Positioned(
        top: 0,
        child: theShadow,
      );
    }
    else{
      return Positioned(
        bottom: 0,
        child: theShadow,
      );
    }
  }
}

class BottomButtonsThatResize extends StatelessWidget {
  const BottomButtonsThatResize({
    Key key,
    @required this.secondary,
    @required this.primary,
  }) : super(key: key);

  final Widget secondary;
  final Widget primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.bottomRight,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            secondary,
            primary,
          ],
        ),
      ),
    );
  }
}