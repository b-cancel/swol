//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feature_discovery/feature_discovery.dart';

//enums
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

//classes
class OnBoarding{
  static bool setgetValue(SharedPreferences prefs, StoredBools storedBool){
    dynamic value = prefs.getBool(storedBool.toString());
    if(value == null){
      prefs.setBool(storedBool.toString(), false);
      return false;
    }
    else return value;
  }

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
    discoverSet(context, AFeature.SwolLogo);
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
    //NOTE: its seperate so we can change it quickly later
    //if need be
    Function secondaryOnTapNext = (onTapNext == null) ? (){} : () => onTapNext();

    Widget invisibleExpandedButton = Expanded(
      child: GestureDetector(
        onTap: () => secondaryOnTapNext(),
        child: Container(
          color: Colors.green,
          child: Text(""),
        ),
      ),
    );

    //build
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isLeft 
        ? CrossAxisAlignment.start 
        : CrossAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            onTap: () => secondaryOnTapNext(),
            child: Container(
              color: Colors.pink,
              alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
              child: Text(
                text,
                textAlign: isLeft ? TextAlign.left : TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          //-------------------------*-------------------------
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                (isLeft == false) ? invisibleExpandedButton : Container(),
                (onTapPrev == null) ? Container()
                : GestureDetector(
                  onTap: () => onTapPrev(),
                  child: Container(
                    color: Colors.yellow,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
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
                                  color: Colors.green.withOpacity(0.5),
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
                ),
                GestureDetector(
                  onTap: (onTapNext == null) ? (){} : () => onTapNext(),
                  child: Container(
                    color: Colors.orange,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: (onTapPrev == null) ? 0 : 16,
                        right: 16,
                        top: 16,
                        bottom: 16,
                      ),
                      child: Center(
                        child: Container(
                          color: Colors.red,
                          child: Text(
                            showDone ? "Done" : "Next",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                isLeft ? invisibleExpandedButton : Container(),
              ],
            ),
          ),
          //-------------------------*-------------------------
        ],
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
      onTap: (onTap == null) ? (){} : () => onTap(),
      //NOTE: invisible container required to make tap target large
      child: Container(
        color: Colors.grey,
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
      onTapNext: () => FeatureDiscovery.dismiss(context),
      onTapPrev: (prevFeature == null) ? null : (){
        continueForward.value = false;
        //because of the above dismiss will react differently
        FeatureDiscovery.dismiss(context);
      },
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
      onTap: () => FeatureDiscovery.dismiss(context),
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
        continueForward.value = true; //reset
        return true; //keep it simple always return true
      },
      onDismiss: () async{
        if(continueForward.value){
          if(nextFeature != null) nextFeature();
        }
        else{
          if(prevFeature != null) prevFeature();
        }
        continueForward.value = true; //reset
        return true; //keep it simple always return true
      },
    );
  }
}