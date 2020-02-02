//widget
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:progress_indicators/progress_indicators.dart';

class PulsingBackground extends StatelessWidget {
  PulsingBackground({
    @required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    //---the glowing indicator that we may or may not use
    
    //max size of pusler given width and nanually set padding
    double maxWidthIndicator = width + (24.0 * 2);

    //in case at some point I want to switch between indicators
    Duration pusleDuration = Duration(milliseconds: 1000); //so its serves as a indicator of change as well
    List<Widget> pulsingBackgrounds = [
      //import 'package:flutter_spinkit/flutter_spinkit.dart';
      SpinKitDualRing(
        lineWidth: maxWidthIndicator/2,
        color: Colors.white,
        size: maxWidthIndicator,
        duration: pusleDuration,
      ),
      SpinKitDoubleBounce( //ABBY LIKED
        color: Colors.white,
        size: maxWidthIndicator,
        duration: pusleDuration,
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
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.red,
          ),
          Container(
            alignment: Alignment.center,
            width: maxWidthIndicator,
            height: maxWidthIndicator,
            child: pulsingBackgrounds[1],
          ),
        ],
      ),
    );
  }
}