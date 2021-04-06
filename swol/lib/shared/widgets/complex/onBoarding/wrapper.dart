//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:feature_discovery/feature_discovery.dart';

//internal
import 'package:swol/shared/widgets/complex/OnBoarding/image.dart';
import 'package:swol/shared/widgets/complex/OnBoarding/text.dart';

class FeatureWrapper extends StatelessWidget {
  FeatureWrapper({
    @required this.featureID,
    @required this.tapTarget,
    @required this.text,
    @required this.child,
    this.top: true,
    this.left: true,
    this.prevFeature,
    this.nextFeature,
    this.doneInsteadOfNext: false,
    this.backgroundColor: Colors.transparent,
  });

  final String featureID;
  final Widget tapTarget;
  final String text;
  final Widget child;
  final bool top;
  final bool left;
  final Function prevFeature;
  final Function nextFeature;
  final bool doneInsteadOfNext;
  final Color backgroundColor;

  //NOTE: [1] Dismiss or [2] OnComplete are both going to be called
  //because we HAVE TO close the current discovery feature
  //before moving onto the next feature discovery or finishing up the discoveries
  //we could have chosen either to use as our "pivot" be we chose [1]

  //NOTE: these feature wrappers can be called or opened up multiple times without being rebuilt
  //so in order for the buttons to continue working as expected
  //we must reset the value notifier after every [1] or [2]

  //Potential User Actions
  //1 -> continue by pressing target
  //2 -> continue by pressing anything else
  //3 -> continue by pressing the next button
  //4 -> go to the previous discovery feature
  //5 -> continue by pressing outside the feature discovery

  //there are 5 user actions each slightly different in their execution of onTap
  //1 -> will automatically call [2] dismiss us and call next feature
  //all the actions below use the pivot
  //2 -> calls [1] manually
  //3 -> calls [1] manually
  //    NOTE: 3 is the same as 2 except we have them seperate
  //          just in case later on we want to seperate these 2 functions
  //          tapping outside the buttons and going next may be unexpected
  //4 -> reconfigured the variable that [1] reacts to, then call [1] manually
  //5 -> will automatically call [1]

  //NOTE: how 4 is the exception

  final ValueNotifier<bool> continueForward = new ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    Widget textWidget = OnBoardingText(
      text: text,
      isLeft: left,
      isTop: top,
      onTapNext: () => FeatureDiscovery.dismissAll(context),
      onTapPrev: (prevFeature == null)
          ? null
          : () {
              continueForward.value = false;
              //because of the above dismiss will react differently
              FeatureDiscovery.dismissAll(context);
            },
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
      onTap: () => FeatureDiscovery.dismissAll(context),
    );

    return DescribedFeatureOverlay(
      featureId: featureID,
      //target
      tapTarget: Stack(
        children: <Widget>[
          IgnorePointer(
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () {},
              backgroundColor: backgroundColor,
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
          ? Theme.of(context).primaryColorDark
          : Theme.of(context).primaryColor,
      //settings
      contentLocation: top ? ContentLocation.below : ContentLocation.above,
      overflowMode: OverflowMode.wrapBackground,
      enablePulsingAnimation: true,
      //child
      child: child,
      //functions
      onComplete: () async {
        if (nextFeature != null) nextFeature();
        continueForward.value = true; //reset
        return true; //keep it simple always return true
      },
      onDismiss: () async {
        if (continueForward.value) {
          if (nextFeature != null) nextFeature();
        } else {
          if (prevFeature != null) prevFeature();
        }
        continueForward.value = true; //reset
        return true; //keep it simple always return true
      },
    );
  }
}
