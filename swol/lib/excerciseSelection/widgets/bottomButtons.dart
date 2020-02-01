//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:page_transition/page_transition.dart';
import 'package:swol/excerciseSelection/widgets/addNewHero.dart';

//internal: shared
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'package:swol/shared/widgets/complex/onBoarding/wrapper.dart';
import 'package:swol/shared/functions/onboarding.dart';

//internal: other
import 'package:swol/pages/search/searchExcercise.dart';
import 'package:swol/main.dart';

//widget
class AddExcerciseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        //NOTE: this must be seperate so the inkwell is visible
        child: FeatureWrapper(
          featureID: AFeature.AddExcercise.toString(),
          tapTarget: FloatingActionButton(
            onPressed: null, //TODO: check
            child: Icon(Icons.add),
          ),
          text: "Tap here to add a\n"
          + "new excercise",
          child: AddNewHero(
            inAppBar: false,
          ),
          top: false,
          left: true,
          prevFeature: (){
            OnBoarding.discoverLearnPage(context);
          },
          doneInsteadOfNext: true,
          nextFeature: (){
            SharedPrefsExt.setInitialControlsShown(true);
          },
        ),
      ),
    );
  }
}

class SearchExcerciseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FeatureWrapper(
          featureID: AFeature.SearchExcercise.toString(),
          tapTarget: FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: null,
          ),
          text: "Tap here to"
          + "\nsearch through"
          + "\nyour excercises",
          child: FloatingActionButton.extended(
            onPressed: (){
              App.navSpread.value = true;
              Navigator.push(
                context, 
                PageTransition(
                  type: PageTransitionType.downToUp, 
                  child: SearchExcercise(),
                ),
              );
            },
            icon: Icon(Icons.search),
            label: Text("Search"),
          ),
          top: false,
          left: false,
        ),
      ),
    );
  }
}

class ButtonSpacer extends StatelessWidget {
  const ButtonSpacer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).primaryColor,
        //56 larger button height
        //48 smaller button height
        height: 16 + 48.0 + 16,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16),
        child: Text(
          "", //BLANK: the add new buttons fills the space now
          //listOfGroupOfExcercises.length.toString() + " Workouts",
          //excercises.value.length.toString() + " Excercises",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class AddExcerciseFiller extends StatelessWidget {
  const AddExcerciseFiller({
    Key key,
  }) : super(key: key);

  /*
  
    finalWidgetList.add(
      SliverFillRemaining(
        hasScrollBody: true,
        fillOverscroll: true,
        child:  Center(
          child: OnBoardingImage(
            width: MediaQuery.of(context).size.width * (7/12),
            imageUrl: "assets/biceps/bottomLeft.png",
          ),
        ),
      ),
    );
    
  */

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: FractionallySizedBox(
          widthFactor: .5,
          child: FittedBox(
            fit: BoxFit.cover,
            child: Text(
              "Add an excercise below!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}