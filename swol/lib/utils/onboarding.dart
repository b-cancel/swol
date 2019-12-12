import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AFeature {SwolLogo, LearnPage, AddExcercise, SearchExcercise}

class OnBoarding{
  static givePermission() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("permissionGiven", true);
  }

  static discoverBasicFeatures(BuildContext context){
    //TODO: only discovery them if they haven't been discovery before
    /*
    FeatureDiscovery.discoverFeatures(
      context,
      [
        //AFeature.SwolLogo.toString(),
        //AFeature.LearnPage.toString(),
        //AFeature.AddExcercise.toString(),
        AFeature.SearchExcercise.toString(),
      ],
    );
    */
  }
}

class OnBoardingText extends StatelessWidget {
  OnBoardingText({
    @required this.text,
    this.left: true,
  });

  final String text;
  final bool left;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        left == false ?  Expanded(
          child: Container(),
        ) : Container(),
        Text(
          text,
          textAlign: left ? TextAlign.left : TextAlign.right,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        left ?  Expanded(
          child: Container(),
        ) : Container(),
      ],
    );
  }
}

class OnBoardingImage extends StatelessWidget {
  OnBoardingImage({
    @required this.width,
    @required this.multiplier,
    @required this.imageUrl,
    this.isLeft,
  });

  final double width;
  final double multiplier;
  final String imageUrl;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
        width: width,
        height: width,
        alignment: (isLeft == null) ? Alignment.center
        : (isLeft) ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          width: width * multiplier,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Image.asset(
              imageUrl,
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
  });

  final String featureID;
  final Widget tapTarget;
  final String text;
  final Widget child;
  final bool top;
  final bool left;

  @override
  Widget build(BuildContext context) {
    Widget textWidget = OnBoardingText(
      text: text,
      left: left,
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
      isLeft: top ? null : (left == false),
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
    );
  }
}