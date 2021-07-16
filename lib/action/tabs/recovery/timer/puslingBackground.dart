//widget
import 'package:flutter/material.dart';

//plugins
import 'package:progress_indicators/progress_indicators.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//widget
class PulsingBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //in case at some point I want to switch between indicators
    Duration pulseDuration = Duration(milliseconds: 1000); 
    //so its serves as a indicator of change as well
    List<Widget> pulsingBackgrounds = [
      //import 'package:flutter_spinkit/flutter_spinkit.dart';
      SpinKitDualRing(
        lineWidth: 1/2,
        color: Colors.white,
        size: 1,
        duration: pulseDuration,
      ),
      SpinKitDoubleBounce( //ABBY LIKED
        color: Colors.white,
        size: 1,
        duration: pulseDuration,
      ),
      //import 'package:loading_indicator/loading_indicator.dart';
      LoadingIndicator(
        indicatorType: Indicator.ballScaleMultiple,
        color: Colors.white,
      ),
      LoadingIndicator(
        indicatorType: Indicator.ballScale, 
        color: Colors.white,
      ),
      //import 'package:progress_indicators/progress_indicators.dart';
      GlowingProgressIndicator( //KOBE LIKED
        child: Container(
          color: Colors.red.withOpacity(0.75),
        ),
        duration: Duration(milliseconds: 5000),
      ),
    ];

    //pusling backgrond widget that may or may not be used
    return Positioned.fill(
      child: Container(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                color: Colors.red,
              ),
            ),
            Positioned.fill(
              child: Container(
                width: 1,
                height: 1,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: pulsingBackgrounds[1],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}