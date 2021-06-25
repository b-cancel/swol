//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:scroll_to_index/scroll_to_index.dart';

//internal: exercise selection
import 'package:swol/pages/selection/widgets/animatedTitle.dart';
import 'package:swol/pages/selection/exerciseList.dart';
import 'package:swol/pages/selection/widgets/uela.dart';

//internal: shared
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'package:swol/shared/functions/onboarding.dart';
import 'package:swol/shared/widgets/simple/scrollToTop.dart';

//Sections and how they are handled
//New => newest additions on bottom
//  since you would probably add your new routine and then work it
//Hidden => newest addition on top [EXCEPTION]
//  since the exercises you most recently archived are the ones most likely to be searched for again
//In Progress => newest additions on bottom
//  since we want to push people to doing super sets with atmost like 3 workouts
//  and while doing super sets you are doing set 1 A, then set 1 B, then set 1 C
//  and you would expect the user to go back to 1A before goign to 1B or 1C so 1A should be on top
//Other => newest additions on the bottom
//  since you want to cycle throughout all your workout routines
//  so if you did legs on monday and 3 other work outs
//  when its monday again you expect that workout to be on top with the first workout you did to be on top in the section

class ExerciseSelectStateless extends StatelessWidget {
  static ValueNotifier<bool> manualOrderUpdate = new ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ExerciseSelect();
  }
}

//main widget
class ExerciseSelect extends StatefulWidget {
  @override
  _ExerciseSelectState createState() => _ExerciseSelectState();
}

class _ExerciseSelectState extends State<ExerciseSelect> {
  final AutoScrollController autoScrollController = new AutoScrollController();
  final ValueNotifier<bool> onTop = new ValueNotifier(true);

  updateOnTopValue() {
    ScrollPosition position = autoScrollController.position;
    double currentOffset = autoScrollController.offset;

    //Determine whether we are on the top of the scroll area
    if (currentOffset <= position.minScrollExtent) {
      onTop.value = true;
    } else
      onTop.value = false;
  }

  @override
  void initState() {
    //create function to be called after the user accept the uela
    Function maybeShowInitialControls = () {
      if (SharedPrefsExt.getInitialControlsShown().value == false) {
        OnBoarding.discoverSwolLogo(context);
      }
    };

    //ask for permission after the frame loads
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      //pop up that comes up asking for permission
      if (SharedPrefsExt.getTermAgreed().value == false) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return UELA(
              afterConfirm: () => maybeShowInitialControls(),
            );
          },
        );
      } else
        maybeShowInitialControls();
    });

    //show or hide the to top button
    autoScrollController.addListener(updateOnTopValue);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    //remove listener
    autoScrollController.removeListener(updateOnTopValue);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //swolheight (Since with mediaquery must be done here)
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double screenWidth = MediaQuery.of(context).size.width;

    //build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: AnimatedTitle(
          screenWidth: screenWidth,
          statusBarHeight: statusBarHeight,
        ),
        actions: <Widget>[
          AnimatedTitleAction(
            screenWidth: screenWidth,
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Stack(
          children: <Widget>[
            //the list or lack of exercises
            //and the search button under certain conditions
            ExerciseList(
              autoScrollController: autoScrollController,
              statusBarHeight: statusBarHeight,
              onTop: onTop,
            ),
            ScrollToTopButton(
              onTop: onTop,
              autoScrollController: autoScrollController,
            ),
          ],
        ),
      ),
    );
  }
}
