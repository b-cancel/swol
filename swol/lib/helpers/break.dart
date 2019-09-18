import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class AnimLiquidIndicator extends StatefulWidget {
  AnimLiquidIndicator({
    @required this.indicatorFill,
  });

  final ValueNotifier<double> indicatorFill;

  @override
  State<StatefulWidget> createState() => _AnimLiquidIndicatorState();
}

class _AnimLiquidIndicatorState extends State<AnimLiquidIndicator> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LiquidCircularProgressIndicator(
      value: widget.indicatorFill.value,
      backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
      borderColor: Colors.transparent,
      borderWidth: 0,
      direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
      //center: 
      
      /*Text(
        "${percentage.toStringAsFixed(0)}%",
        style: TextStyle(
          color: Colors.lightBlueAccent,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      */
    );
  }
}