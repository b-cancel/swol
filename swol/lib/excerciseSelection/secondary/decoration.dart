//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//internal
import 'package:swol/other/theme.dart';

class SwolLogo extends StatelessWidget {
  const SwolLogo({
    this.height,
    Key key,
  }) : super(key: key);

  final height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: FittedBox(
        fit: BoxFit.cover,
        child: DefaultTextStyle(
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          child: Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(1, 0),
                child: Text(
                  "S W O L",
                  style: TextStyle(
                    color: MyTheme.dark.accentColor,
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(-1, 0),
                child: Text(
                  "S W O L",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              Text(
                "S W O L",
                style: TextStyle(
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PumpingHeart extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  PumpingHeart({
    Key key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 2400),
    this.controller,
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        assert(size != null),
        super(key: key);

  final Color color;
  final double size;
  final IndexedWidgetBuilder itemBuilder;
  final Duration duration;
  final AnimationController controller;

  @override
  _PumpingHeartState createState() => _PumpingHeartState();
}

class _PumpingHeartState extends State<PumpingHeart>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _anim1;

  @override
  void initState() {
    super.initState();
    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..repeat();
    _anim1 = Tween(begin: 1.0, end: 1.25).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: MyCurve()),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _anim1,
      child: _itemBuilder(0),
    );
  }

  Widget _itemBuilder(int index) {
    return widget.itemBuilder != null
      ? widget.itemBuilder(context, index)
      : Icon(
        FontAwesomeIcons.solidHeart,
        color: widget.color,
        size: widget.size,
      );
  }
}