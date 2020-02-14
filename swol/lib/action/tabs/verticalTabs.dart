//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/action/doneButton/doneWidget.dart';
import 'package:swol/action/tabs/record/setRecord.dart';
import 'package:swol/action/tabs/recovery/recovery.dart';
import 'package:swol/action/tabs/suggest/suggest.dart';
import 'package:swol/action/page.dart';
import 'package:swol/shared/structs/anExcercise.dart';

/// A vertical tab widget for flutter
class VerticalTabs extends StatefulWidget {
  final AnExcercise excercise;
  final double statusBarHeight;

  VerticalTabs({
    @required this.excercise,
    @required this.statusBarHeight,
  });

  @override
  _VerticalTabsState createState() => _VerticalTabsState();
}

class _VerticalTabsState extends State<VerticalTabs> with TickerProviderStateMixin {
  Duration transitionDuration = Duration(milliseconds: 3000); //TODO: back to 300

  //for the "hero" widget (if not up then down)
  ValueNotifier<bool> goalSetUp;

  //handle page switches
  PageController pageViewController;

  //init
  @override
  void initState() {
    //initally set the notifiers
    //after this our notifiers initially set our controllers
    //our controllers update our notifiers
    //and then our notifiers ONLY update our temps under very specific conditions
    ExcercisePage.setWeight.value = widget?.excercise?.tempWeight ?? "";
    ExcercisePage.setReps.value = widget?.excercise?.tempReps ?? "";

    //set the first page we will be at based on startTimerValue
    bool timerNotStarted = widget.excercise.tempStartTime.value == AnExcercise.nullDateTime;
    int initialPage = timerNotStarted ? 0 : 2; //grab
    ExcercisePage.pageNumber.value = initialPage; //update globally

    //set hero position depending on start page (updated when pages switch)
    goalSetUp = new ValueNotifier<bool>(initialPage == 0);

    //have the page controller go to that initial page
    pageViewController = PageController(
      keepPage: false, //we need to use the on init of various pages
      initialPage: initialPage,
    );

    //listen to changes on pageNumber to then go to that page
    ExcercisePage.pageNumber.addListener(updatePage);

    //super init
    super.initState();
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
              statusBarHeight: widget.statusBarHeight,
              heroUp: goalSetUp,
              heroAnimDuration: transitionDuration,
              heroAnimTravel: totalTravel,
            ),
            SetRecord(
              excercise: widget.excercise,
              statusBarHeight: widget.statusBarHeight,
              heroUp: goalSetUp,
              heroAnimDuration: transitionDuration,
              heroAnimTravel: totalTravel,
            ),
            Recovery(
              excercise: widget.excercise,
            ),
          ],
        ),
        //must be on top... other wise it isnt clickable
        DoneButton(
          excercise: widget.excercise,
          showOrHideDuration: transitionDuration,
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

    //animated to right page
    pageViewController.animateToPage(
      ExcercisePage.pageNumber.value, 
      duration: transitionDuration, 
      curve: Curves.easeInOut,
    );

    //handle the cross page "hero"
    //after waiting "a couple of frames" for the other page to start showing up
    //TODO: find a more fool proof way of doing this
    //perhaps by using offsets and recursion to check where they are
    //assuming they should be at some half way point if animation has begun
    WidgetsBinding.instance.addPostFrameCallback((_){
      WidgetsBinding.instance.addPostFrameCallback((_){
        WidgetsBinding.instance.addPostFrameCallback((_){
          goalSetUp.value = (ExcercisePage.pageNumber.value == 0);
        });
      });
    });
  }
}