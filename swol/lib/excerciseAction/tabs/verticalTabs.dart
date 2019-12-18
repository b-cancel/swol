//MODIFICATION OF PLUGIN FOUND HERE
//https://pub.dev/packages/vertical_tabs#-readme-tab-

//dart
import 'dart:math' as math;

//flutter
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

//internal: tabs
import 'package:swol/excerciseAction/tabs/record/setRecord.dart';
import 'package:swol/excerciseAction/tabs/recovery/recovery.dart';
import 'package:swol/excerciseAction/tabs/suggest/suggest.dart';

/// A vertical tab widget for flutter
class VerticalTabs extends StatefulWidget {
  final int excerciseID;
  final double maxHeight;

  VerticalTabs({
    @required this.excerciseID,
    @required this.maxHeight,
  });

  @override
  _VerticalTabsState createState() => _VerticalTabsState();
}

class _VerticalTabsState extends State<VerticalTabs> with TickerProviderStateMixin {
  var carousel;
  int tab;

  allSetsComplete(){
    print("fill all sets complete function");
  }

  toPage(int pageID){ //0->2
    print("to page: " + pageID.toString());
    carousel.animateToPage(
      pageID, 
      duration: Duration(milliseconds: 250), 
      curve: Curves.easeInOut,
    );
  }

  //init
  @override
  void initState() {
    //TODO: select the first tab based on how far we are into the workout
    //for now this functionality is test our randomly
    var rng = new math.Random();
    tab = (rng.nextInt(3)).clamp(0, 2);

    //carousel
    carousel = CarouselSlider(
      initialPage: tab,
      viewportFraction: 1.0,
      //TODO: when we are done with debuging we can uncomment this
      //scrollPhysics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      height: widget.maxHeight,
      items: [
        Suggestion(
          excerciseID: widget.excerciseID,
          allSetsComplete: allSetsComplete,
          recordSet: () => toPage(1),
        ),
        SetRecord(
          excerciseID: widget.excerciseID,
          backToSuggestion: () => toPage(0),
          setBreak: () => toPage(2),
        ),
        Recovery(
          excerciseID: widget.excerciseID,
          allSetsComplete: allSetsComplete,
          //TODO: hold the back button should also do the same as below
          //TODO: toast that the timer will not reset no matter what
          backToRecordSet: () => toPage(1),
          nextSet: () => toPage(0),
        ),
      ],
    );

    //super init
    super.initState();
  }

  //build
  @override
  Widget build(BuildContext context) {
    return carousel;
  }
}