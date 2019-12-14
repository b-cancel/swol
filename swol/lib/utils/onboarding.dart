import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AFeature {
  //permission
  SwolLogo, LearnPage, AddExcercise, SearchExcercise, //initial controls
}

enum StoredBools {
  TermsAgreed, //permission
  InitialControlsShown, //inital controls
  SearchButtonShown,
  CalculatorShown, 
  SettingsShown,
}

class OnBoarding{
  static bool setgetValue(SharedPreferences prefs, StoredBools storedBool){
    dynamic value = prefs.getBool(storedBool.toString());
    if(value == null){
      prefs.setBool(storedBool.toString(), false);
      return false;
    }
    else return true;
  }

  static bool showDebuging = false;

  static givePermission() => boolSet(StoredBools.TermsAgreed);
  static initialControlsShown() => boolSet(StoredBools.InitialControlsShown);
  static searchButtonShown() => boolSet(StoredBools.SearchButtonShown);
  static calculatorShown() => boolSet(StoredBools.CalculatorShown);
  static settingsShown() => boolSet(StoredBools.SettingsShown);

  static boolSet(StoredBools storedBool) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(storedBool.toString(), true);
  }

  //-------------------------*-------------------------

  static discoverSwolLogo(BuildContext context){
    if(OnBoarding.showDebuging) print("before feature discovery");
    AFeature featureToDiscover = AFeature.SwolLogo;
    if(OnBoarding.showDebuging) print("feature to discover: " + featureToDiscover.toString());
    discoverSet(context, featureToDiscover);
    if(OnBoarding.showDebuging) print("after feature discovery");
  }

  static discoverLearnPage(BuildContext context){
    discoverSet(context, AFeature.LearnPage);
  }

  static discoverAddExcercise(BuildContext context){
    discoverSet(context, AFeature.AddExcercise);
  }

  static discoverSearchExcercise(BuildContext context){
    discoverSet(context, AFeature.SearchExcercise);
  }

  //utility function because Feature discovery seems to prefer sets
  static discoverSet(BuildContext context, AFeature featureName){
    Set<String> aSet = new Set<String>();
    aSet.add(featureName.toString());
    FeatureDiscovery.discoverFeatures(context, aSet);
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
      onTap: (onTapNext == null) ? null : () => onTapNext(),
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
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: isLeft 
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
              children: <Widget>[
                (onTapPrev == null) ? Container()
                : GestureDetector(
                  onTap: () => onTapPrev(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: ClipRRect(
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: (onTapPrev == null) ? 0 : 16,
                    top: 8 + 8.0,
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
    this.doneInsteadOfNext: false,
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
      if(OnBoarding.showDebuging) print("dimssin the previous feature discovery");
      FeatureDiscovery.dismiss(context);
      if(OnBoarding.showDebuging) print("go to prev feature for \"" + text + "\"");
      prevFeature();
      if(OnBoarding.showDebuging) print("after gone to next feature");
    };

    Widget textWidget = OnBoardingText(
      text: text,
      isLeft: left,
      onTapNext: dismissThenNextFeature,
      onTapPrev: dismissThenPrevFeature,
      showDone: doneInsteadOfNext,
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