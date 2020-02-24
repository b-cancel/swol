//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/action/doneButton/doneWidget.dart';
import 'package:swol/action/tabs/record/setRecord.dart';
import 'package:swol/action/tabs/recovery/recovery.dart';
import 'package:swol/action/tabs/suggest/suggest.dart';
import 'package:swol/action/page.dart';

/// A vertical tab widget for flutter
class VerticalTabs extends StatefulWidget {
  final AnExcercise excercise;
  final double statusBarHeight;
  final Duration transitionDuration;

  VerticalTabs({
    @required this.excercise,
    @required this.statusBarHeight,
    @required this.transitionDuration,
  });

  @override
  _VerticalTabsState createState() => _VerticalTabsState();
}

class _VerticalTabsState extends State<VerticalTabs> with TickerProviderStateMixin {
  //for the "hero" widget (if not up then down)
  ValueNotifier<bool> goalSetUp;

  //handle page switches
  PageController pageViewController;

  //init
  @override
  void initState() {
    //super init
    super.initState();

    //set the first page we will be at based on startTimerValue
    int initialPage;
    bool timerNotStarted = widget.excercise.tempStartTime.value == AnExcercise.nullDateTime;
    if(timerNotStarted){
      if(widget.excercise.lastWeight == null) initialPage = 1;
      else initialPage = 0;
    }
    else initialPage = 2;
    
    //set hero position depending on start page (updated when pages switch)
    goalSetUp = new ValueNotifier<bool>(initialPage == 0);

    //update value globally
    ExcercisePage.pageNumber.value = initialPage;

    //initally set the notifiers
    //after this our notifiers initially set our controllers
    //our controllers update our notifiers
    //and then our notifiers ONLY update our temps under very specific conditions
    int tempWeight = widget?.excercise?.tempWeight;
    int tempReps = widget?.excercise?.tempReps;
    //extra step needed because null.toString() isn't null
    ExcercisePage.setWeight.value = (tempWeight != null) ? tempWeight.toString() : "";
    ExcercisePage.setReps.value = (tempReps != null) ? tempReps.toString() : "";

    //have the page controller go to that initial page
    pageViewController = PageController(
      keepPage: false, //we need to use the on init of various pages
      initialPage: initialPage,
    );

    //listen to changes on pageNumber to then go to that page
    ExcercisePage.pageNumber.addListener(updatePage);
  }

  //dipose
  @override
  void dispose() { 
    //remove listener
    ExcercisePage.pageNumber.removeListener(updatePage);

    //remove controller
    pageViewController.dispose();
    
    //remove notifier
    goalSetUp.dispose();

    //super dispose
    super.dispose();
  }

  //build
  @override
  Widget build(BuildContext context) {
    //both values grabbed raw
    double bottomPadding = 24.0 + 24.0 + 40.0 + 24;
    double topPadding = 16;

    //travel bottomPadding + bottomPadding + toPadding in 300 ms
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
              excercise: widget.excercise,
              heroUp: goalSetUp,
              heroAnimDuration: widget.transitionDuration,
              heroAnimTravel: totalTravel,
            ),
            SetRecord(
              excercise: widget.excercise,
              statusBarHeight: widget.statusBarHeight,
              heroUp: goalSetUp,
              heroAnimDuration: widget.transitionDuration,
              heroAnimTravel: totalTravel,
            ),
            Recovery(
              transtionDuration: widget.transitionDuration,
              excercise: widget.excercise,
            ),
          ],
        ),
        //must be on top... other wise it isnt clickable
        FloatingDoneButton(
          excercise: widget.excercise,
          showOrHideDuration: widget.transitionDuration,
          animationCurve: Curves.easeInOut,
        ),
      ],
    );
  }

  //NOTE: since this is triggered by a change to a notifier
  //we will never go to a page that we are already at
  updatePage(){
    //close the keybaord since we have been on page 1 (record)
    FocusScope.of(context).unfocus();

    //grab start offset so we know when to start the "hero" transition
    waitForTransitionBegin(pageViewController.offset);

    //animated to right page
    pageViewController.animateToPage(
      ExcercisePage.pageNumber.value, 
      duration: widget.transitionDuration, 
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
  waitForTransitionBegin(double startOffset){
    WidgetsBinding.instance.addPostFrameCallback((_){
      double currentOffset = pageViewController.offset;
      if(currentOffset == startOffset) waitForTransitionBegin(startOffset);
      else{
        //get the goal set animation to begin
        goalSetUp.value = (ExcercisePage.pageNumber.value == 0);
        //NOTE: although it seems like it
        //we can't use this to also autofocus on the field
        //AS FAST AS POSSIBLE because of how the carousel works
      }
    });
  }
}