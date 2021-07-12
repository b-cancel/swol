//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/action/tabs/recovery/recovery.dart';
import 'package:swol/action/doneButton/doneWidget.dart';
import 'package:swol/action/tabs/record/setRecord.dart';
import 'package:swol/action/tabs/suggest/suggest.dart';
import 'package:swol/action/page.dart';

/// A vertical tab widget for flutter
class VerticalTabs extends StatefulWidget {
  final AnExercise exercise;
  final double statusBarHeight;
  final int initialPage;

  VerticalTabs({
    required this.exercise,
    required this.statusBarHeight,
    required this.initialPage,
  });

  @override
  _VerticalTabsState createState() => _VerticalTabsState();
}

class _VerticalTabsState extends State<VerticalTabs>
    with TickerProviderStateMixin {
  //for the "hero" widget (if not up then down)
  late ValueNotifier<bool> goalSetUp;

  //handle page switches
  late PageController pageViewController;

  //init
  @override
  void initState() {
    //super init
    super.initState();

    //set hero position depending on start page (updated when pages switch)
    goalSetUp = new ValueNotifier<bool>(
      widget.initialPage == 0,
    );

    //update value globally
    ExercisePage.pageNumber.value = widget.initialPage;

    //have the page controller go to that initial page
    pageViewController = PageController(
      keepPage: false, //we need to use the on init of various pages
      initialPage: widget.initialPage,
    );

    //listen to changes on pageNumber to then go to that page
    ExercisePage.pageNumber.addListener(updatePage);
  }

  //dipose
  @override
  void dispose() {
    //remove listener
    ExercisePage.pageNumber.removeListener(updatePage);

    //remove controller
    pageViewController.dispose();

    //remove notifier
    goalSetUp.dispose();

    //super dispose
    super.dispose();
  }

  //here so a break in connection isnt made
  final FocusNode weightFocusNode = new FocusNode();
  final FocusNode repsFocusNode = new FocusNode();

  //build
  @override
  Widget build(BuildContext context) {
    //both values grabbed raw
    double bottomPadding = 24.0 + 24.0 + ExercisePage.mainButtonsHeight + 24;
    double topPadding = 16; //TODO: is this actually status bar height

    //travel bottomPadding + bottomPadding + topPadding in 300 ms
    //10 feet in 5 seconds, 2 feets per second
    //how long to travel 3 feet? 3/2 = 1.5 seconds
    double totalTravel = (bottomPadding * 2) + topPadding;

    //all the stuffs
    return Stack(
      children: <Widget>[
        PageView(
          controller: pageViewController,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Suggestion(
              exercise: widget.exercise,
              heroUp: goalSetUp,
              heroAnimTravel: totalTravel,
            ),
            SetRecord(
              exercise: widget.exercise,
              statusBarHeight: widget.statusBarHeight,
              heroUp: goalSetUp,
              heroAnimTravel: totalTravel,
              weightFocusNode: weightFocusNode,
              repsFocusNode: repsFocusNode,
            ),
            Recovery(
              exercise: widget.exercise,
            ),
          ],
        ),
        //must be on top... other wise it isnt clickable
        Theme(
          data: MyTheme.light,
          child: FloatingDoneButton(
            exercise: widget.exercise,
            animationCurve: Curves.easeInOut,
            cardColor: Theme.of(context).cardColor,
          ),
        ),
      ],
    );
  }

  //NOTE: since this is triggered by a change to a notifier
  //we will never go to a page that we are already at
  updatePage() {
    //close the keybaord since we MAY have been on page 1 (record)
    FocusScope.of(context).unfocus();

    //grab start offset so we know when to start the "hero" transition
    waitForTransitionBegin(pageViewController.offset);

    //animated to right page
    pageViewController.animateToPage(
      ExercisePage.pageNumber.value,
      duration: ExercisePage.transitionDuration,
      curve: Curves.easeInOut,
    );
  }

  //NOTE: we don't need to plan for the rare case
  //where before the animation starts
  //we want to go to another page
  //because there is no way that can happen because
  //1. only about 3 frames pass
  //2. if we are moving towards the "record" page
  //    until the transition begins no other navigation buttons are expose
  //3. if we are moving towards the "suggest page"
  //    the next button is immediately hidden
  waitForTransitionBegin(double startOffset) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      double currentOffset = pageViewController.offset;
      if (currentOffset == startOffset)
        waitForTransitionBegin(startOffset);
      else {
        //get the goal set animation to begin
        goalSetUp.value = (ExercisePage.pageNumber.value == 0);
        //NOTE: although it seems like it
        //we can't use this to also autofocus on the field
        //AS FAST AS POSSIBLE because of how the carousel works
      }
    });
  }
}
