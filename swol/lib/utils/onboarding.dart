import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AFeature {SwolLogo, LearnPage, AddExcercise, SearchExcercise}

class OnBoarding{
  static givePermission() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("permissionGiven", true);
  }

  static discoverSwolLogo(BuildContext context){
    print("why arent you discovering the swol logo????");
    print("the feature is called: " + AFeature.SwolLogo.toString());
    FeatureDiscovery.discoverFeatures( context,
    [AFeature.SwolLogo.toString()]);
  }

  static discoverLearnPage(BuildContext context){
    FeatureDiscovery.discoverFeatures( context,
    [AFeature.LearnPage.toString()]);
  }

  static discoverAddExcercise(BuildContext context){
    FeatureDiscovery.discoverFeatures( context,
    [AFeature.AddExcercise.toString()]);
  }

  static discoverSearchExcercise(BuildContext context){
    FeatureDiscovery.discoverFeatures( context,
    [AFeature.SearchExcercise.toString()]);
  }
}

class OnBoardingText extends StatelessWidget {
  OnBoardingText({
    @required this.text,
    this.isLeft: true,
    this.onTapNext,
    this.onTapPrev,
    @required this.showDone,
  });

  final String text;
  final bool isLeft;
  final Function onTapNext;
  final Function onTapPrev;
  final bool showDone;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (onTapNext == null) ? null : (){
        print("----------------ON TAP NEXT");
        onTapNext();
      },
      //NOTE: invisible container required to make tap target large
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isLeft 
          ? CrossAxisAlignment.start 
          : CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: isLeft 
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  text,
                  textAlign: isLeft ? TextAlign.left : TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: isLeft 
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
                children: <Widget>[
                  (onTapPrev == null) ? Container()
                  : ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        highlightColor: Theme.of(context).accentColor,
                        onTap: () => onTapPrev(),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            //color: Colors.blue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 2,
                            )
                          ),
                          child: Text(
                            "Back",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: (onTapPrev == null) ? 0 : 16,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: Text(
                        showDone ? "Done" : "Next",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OnBoardingImage extends StatelessWidget {
  OnBoardingImage({
    @required this.width,
    @required this.multiplier,
    @required this.imageUrl,
    this.isLeft,
    this.onTap,
  });

  final double width;
  final double multiplier;
  final String imageUrl;
  final bool isLeft;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (onTap == null) ? null : () => onTap(),
      //NOTE: invisible container required to make tap target large
      child: Container(
        color: Colors.transparent,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            width: width,
            height: width,
            alignment: (isLeft == null) ? Alignment.center
            : (isLeft) ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: width * multiplier,
              child: Image.asset(
                imageUrl,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
  });

  final String featureID;
  final Widget tapTarget;
  final String text;
  final Widget child;
  final bool top;
  final bool left;
  final Function prevFeature;
  final Function nextFeature;

  @override
  Widget build(BuildContext context) {
    Function dismissThenNextFeature = (nextFeature == null) 
    ? () => FeatureDiscovery.dismiss(context) 
    : (){
      FeatureDiscovery.dismiss(context);
      nextFeature();
    };

    Function dismissThenPrevFeature = (prevFeature == null) ? null 
    : (){
      FeatureDiscovery.dismiss(context);
      print("prev feature for " + text);
      prevFeature();
    };

    Widget textWidget = OnBoardingText(
      text: text,
      isLeft: left,
      onTapNext: dismissThenNextFeature,
      onTapPrev: dismissThenPrevFeature,
      showDone: (nextFeature == null),
    );

    String imageUrl;
    if(top && left) imageUrl = "assets/biceps/topLeft.png";
    else if(top && left == false) imageUrl = "assets/biceps/topRight.png";
    else if(top == false && left) imageUrl = "assets/biceps/bottomLeft.png";
    else imageUrl = "assets/biceps/bottomRight.png";

    Widget image = OnBoardingImage(
      width: MediaQuery.of(context).size.width,
      multiplier: (2/3),
      imageUrl: imageUrl,
      //NOTE: the top onBoardings are center aligned
      isLeft: top ? null : (left == false),
      onTap: dismissThenNextFeature,
    );

    return DescribedFeatureOverlay(
      featureId: featureID,
      //target
      tapTarget: tapTarget,
      targetColor: top ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark,
      //background
      title: top ? textWidget : image,
      textColor: Colors.white,
      description: top ? image : textWidget,
      backgroundColor: top ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColor,
      //settings
      contentLocation: top ? ContentLocation.below : ContentLocation.above,
      overflowMode: OverflowMode.wrapBackground,
      enablePulsingAnimation: true,
      //child
      child: child,
      //functions
      onComplete: () async{
        if(nextFeature != null) nextFeature();
        return true;
      },
      onDismiss: () async{
        if(nextFeature != null) nextFeature();
        return true;
      },
    );
  }
}