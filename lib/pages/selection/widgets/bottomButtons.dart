//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:page_transition/page_transition.dart';
import 'package:swol/action/page.dart';

//internal: shared
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'package:swol/shared/widgets/complex/onBoarding/wrapper.dart';
import 'package:swol/shared/functions/onboarding.dart';
import 'package:swol/shared/methods/exerciseData.dart';

//internal: other
import 'package:swol/pages/selection/widgets/addNewHero.dart';
import 'package:swol/pages/search/searchExercise.dart';
import 'package:swol/main.dart';

//widget
class AddExerciseButton extends StatelessWidget {
  AddExerciseButton({
    required this.longTransitionDuration,
  });

  final Duration longTransitionDuration;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        //NOTE: this must be seperate so the inkwell is visible
        child: FeatureWrapper(
          featureID: AFeature.AddExercise.toString(),
          tapTarget: FloatingActionButton(
            onPressed: null,
            backgroundColor: Theme.of(context).accentColor,
            child: Icon(Icons.add),
          ),
          text: "Tap here to ADD a" + " new exercise",
          child: AddNewHero(
            inAppBar: false,
            longTransitionDuration: longTransitionDuration,
          ),
          top: false,
          left: true,
          prevFeature: () {
            OnBoarding.discoverLearnPage(context);
          },
          doneInsteadOfNext: true,
          nextFeature: () {
            SharedPrefsExt.setInitialControlsShown(true);
          },
        ),
      ),
    );
  }
}

class SearchExerciseButton extends StatefulWidget {
  @override
  _SearchExerciseButtonState createState() => _SearchExerciseButtonState();
}

class _SearchExerciseButtonState extends State<SearchExerciseButton> {
  late bool showSearch;

  updateState() {
    if (mounted) {
      setState(() {});
      showSearch = ((ExerciseData.exercisesOrder?.value.length ?? 0) > 1);
      if (SharedPrefsExt.getSearchShown().value == false && showSearch) {
        OnBoarding.discoverSearchExercise(context);
      }
    }
  }

  @override
  void initState() {
    showSearch = ((ExerciseData.exercisesOrder?.value.length ?? 0) > 1);
    ExerciseData.exercisesOrder?.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() {
    ExerciseData.exercisesOrder?.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Visibility(
        visible: showSearch,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FeatureWrapper(
            featureID: AFeature.SearchExercise.toString(),
            tapTarget: FloatingActionButton(
              child: Icon(Icons.search),
              backgroundColor: Theme.of(context).accentColor,
              onPressed: null,
            ),
            text: "Tap here to" + " SEARCH through" + " your exercises",
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).accentColor,
              onPressed: () {
                App.navSpread.value = true;
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    duration: ExercisePage.transitionDuration,
                    child: SearchExercise(),
                  ),
                );
              },
              child: Icon(Icons.search),
            ),
            top: false,
            left: false,
            doneInsteadOfNext: true,
            nextFeature: () {
              SharedPrefsExt.setSearchShown(true);
            },
          ),
        ),
      ),
    );
  }
}

class ButtonSpacer extends StatelessWidget {
  const ButtonSpacer({
    Key? key,
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
          //listOfGroupOfExercises.length.toString() + " Workouts",
          //exercises.value.length.toString() + " Exercises",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class AddExerciseFiller extends StatelessWidget {
  const AddExerciseFiller({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      fillOverscroll: true,
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Text(
            "add an exercise below",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
