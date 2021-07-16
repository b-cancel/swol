//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:feature_discovery/feature_discovery.dart';

//internal
import 'package:swol/shared/widgets/complex/OnBoarding/image.dart';
import 'package:swol/shared/widgets/complex/OnBoarding/text.dart';

//oncomplete... when touching highlighted thing
//ondismiss... when touching out of highlighted area
class FeatureWrapper extends StatelessWidget {
  FeatureWrapper({
    required this.featureID,
    required this.tapTarget,
    required this.text,
    required this.child,
    this.top: true,
    this.left: true,
    this.prevFeature,
    required this.nextFeature,
    this.doneInsteadOfNext: false,
    this.backgroundColor: Colors.transparent,
  });

  final String featureID;
  final Widget tapTarget;
  final String text;
  final Widget child;
  final bool top;
  final bool left;
  final Function? prevFeature;
  final Function nextFeature;
  final bool doneInsteadOfNext;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    Function toNext = () {
      FeatureDiscovery.completeCurrentStep(context);
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        nextFeature();
      });
    };
    Function? toPrev = (prevFeature != null)
        ? () {
            FeatureDiscovery.completeCurrentStep(context);
            prevFeature!();
          }
        : null;

    Widget textWidget = OnBoardingText(
      text: text,
      isLeft: left,
      isTop: top,
      onTapNext: () => toNext(),
      onTapPrev: (toPrev != null) ? () => toPrev() : null,
      showDone: doneInsteadOfNext,
    );

    String imageUrl;
    if (top && left)
      imageUrl = "assets/biceps/topLeft.png";
    else if (top && left == false)
      imageUrl = "assets/biceps/topRight.png";
    else if (top == false && left)
      imageUrl = "assets/biceps/bottomLeft.png";
    else
      imageUrl = "assets/biceps/bottomRight.png";

    Widget image = OnBoardingImage(
      width: MediaQuery.of(context).size.width,
      multiplier: (2 / 3),
      imageUrl: imageUrl,
      //NOTE: the top onBoardings are center aligned
      isLeft: top ? null : (left == false),
      onTap: null,
    );

    return DescribedFeatureOverlay(
      featureId: featureID,
      //target
      tapTarget: Stack(
        children: <Widget>[
          IgnorePointer(
            child: FloatingActionButton(
              heroTag: null,
              onPressed: null,
              backgroundColor: backgroundColor.withOpacity(0.5),
              child: Text(""),
            ),
          ),
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.contain,
              child: tapTarget,
            ),
          ),
        ],
      ),
      targetColor: top
          ? Theme.of(context).primaryColor
          : Theme.of(context).primaryColorDark,
      //background
      title: top ? textWidget : image,
      textColor: Colors.white,
      description: top ? image : textWidget,
      backgroundColor: top
          ? Theme.of(context).primaryColorDark.withOpacity(0.25)
          : Theme.of(context).primaryColor.withOpacity(0.25),
      //settings
      contentLocation: top ? ContentLocation.below : ContentLocation.above,
      overflowMode: OverflowMode.wrapBackground,
      enablePulsingAnimation: true,
      //child
      child: child,
      //functions
      onBackgroundTap: () async {
        print("on background tap");
        return false;
      },
      onComplete: () async {
        print("on complete");
        return false;
      },
      onDismiss: () async {
        print("on dismiss");
        return false;
      },
    );
  }
}
