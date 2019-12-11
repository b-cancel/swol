//flutter
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';

//plugin
import 'package:page_transition/page_transition.dart';

//internal
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/excerciseSearch/searchExcercise.dart';
import 'package:swol/excerciseSelection/secondary/addNewHero.dart';
import 'package:swol/excerciseSelection/secondary/persistentHeaderDelegate.dart';
import 'package:swol/utils/onboarding.dart';

class AddExcerciseButton extends StatelessWidget {
  const AddExcerciseButton({
    Key key,
    @required this.navSpread,
    @required this.screenWidth,
  }) : super(key: key);

  final ValueNotifier<bool> navSpread;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        //NOTE: this must be seperate so the inkwell is visible
        child: DescribedFeatureOverlay(
          featureId: 'add_excercise', // Unique id that identifies this overlay.
          //target
          tapTarget: FloatingActionButton(
            onPressed: (){
              //print("tapped");
            },
            child: Icon(Icons.add),
          ),
          targetColor: Theme.of(context).primaryColorDark,
          //test and other description
          title: OnBoardingImage(
            width: MediaQuery.of(context).size.width,
            multiplier: (2/3),
            imageUrl: "assets/biceps/bottomLeft.png",
            isLeft: false,
          ),
          description: OnBoardingText(
            text: "Tap here to add a\n"
            + "new excercise",
            toLeft: true,
          ),
          textColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          //settings
          contentLocation: ContentLocation.above,
          overflowMode: OverflowMode.wrapBackground,
          enablePulsingAnimation: true,
          //child
          child: AddNewHero(
            inAppBar: false,
            navSpread: navSpread,
          ),
        ),
      ),
    );
  }
}

class SearchExcerciseButton extends StatelessWidget {
  const SearchExcerciseButton({
    @required this.navSpread,
    @required this.screenWidth,
    Key key,
  }) : super(key: key);
  
  final ValueNotifier<bool> navSpread;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    /*
    TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    */
    return Positioned(
      right: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DescribedFeatureOverlay(
          featureId: 'search_excercise', // Unique id that identifies this overlay.
          //target
          tapTarget: FloatingActionButton(
            onPressed: (){
              //print("tapped");
            },
            child: Icon(Icons.search),
          ),
          targetColor: Theme.of(context).primaryColorDark,
          //background
          title: OnBoardingImage(
            width: MediaQuery.of(context).size.width,
            multiplier: (2/3),
            isLeft: true,
            imageUrl: "assets/biceps/bottomRight.png",
          ),
          description: OnBoardingText(
            text: "Tap here to"
            + "\nsearch through"
            + "\nyour excercises",
            toLeft: false,
          ),
          textColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          //settings
          contentLocation: ContentLocation.above,
          overflowMode: OverflowMode.wrapBackground,
          enablePulsingAnimation: true,
          //child
          child: FloatingActionButton.extended(
            onPressed: (){
              navSpread.value = true;
              Navigator.push(
                context, 
                PageTransition(
                  type: PageTransitionType.downToUp, 
                  child: SearchExcercise(
                    navSpread: navSpread,
                  ),
                ),
              );
            },
            icon: Icon(Icons.search),
            label: Text("Search"),
          ),
        ),
      ),
    );
  }
}

class HeaderForOneHandedUse extends StatelessWidget {
  const HeaderForOneHandedUse({
    Key key,
    @required this.listOfGroupOfExcercises,
    @required this.newWorkoutSection,
    @required this.hiddenWorkoutSection,
    @required this.inprogressWorkoutSection,
  }) : super(key: key);

  final List<List<AnExcercise>> listOfGroupOfExcercises;
  final bool newWorkoutSection;
  final bool hiddenWorkoutSection;
  final bool inprogressWorkoutSection;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: false,
      floating: false,
      delegate: PersistentHeaderDelegate(
        semiClosedHeight: 60,
        openHeight: MediaQuery.of(context).size.height / 3,
        closedHeight: 0,
        workoutCount: listOfGroupOfExcercises.length 
        //exclude new workouts
        - (newWorkoutSection ? 1 : 0) 
        //exclude hidden workouts
        - (hiddenWorkoutSection ? 1 : 0)
        //exclude in progress since they either
        //- create a new section
        //- or replace a section
        - (inprogressWorkoutSection ? 1 : 0),
      ),
    );
  }
}

class AddExcerciseFiller extends StatelessWidget {
  const AddExcerciseFiller({
    Key key,
  }) : super(key: key);

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