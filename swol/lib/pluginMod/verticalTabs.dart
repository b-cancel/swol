//MODIFICATION OF PLUGIN FOUND HERE
//https://pub.dev/packages/vertical_tabs#-readme-tab-

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:swol/tabs/break.dart';
import 'package:swol/tabs/setRecord.dart';
import 'package:swol/tabs/suggest.dart';
import 'package:swol/utils/data.dart';

/// A vertical tab widget for flutter
class VerticalTabs extends StatefulWidget {
  final Key key;
  final int excerciseID;
  final Duration changePageDuration;
  final Curve changePageCurve;

  VerticalTabs({
    this.key,
    @required this.excerciseID,
    this.changePageCurve = Curves.easeInOut,
    this.changePageDuration = const Duration(milliseconds: 300),
  });

  @override
  _VerticalTabsState createState() => _VerticalTabsState();
}

class _VerticalTabsState extends State<VerticalTabs> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _changePageByTapView;
  AnimationController animationController;
  Animation<double> animation;
  Animation<RelativeRect> rectAnimation;
  PageController pageController = PageController();
  List<AnimationController> animationControllers = [];
  ScrollPhysics pageScrollPhysics = AlwaysScrollableScrollPhysics();

  //for timer
  ValueNotifier<Duration> recoveryDuration;

  @override
  void initState() {
    //NOTE I know for a fact that we only have 3 tabs
    for (int i = 0; i < 3; i++) {
      animationControllers.add(AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ));
    }

    //select the first tab based on how far we are into the workout
    var rng = new math.Random();
    int tab = rng.nextInt(3);
    print("tab picked: " + tab.toString());
    WidgetsBinding.instance.addPostFrameCallback((_){
      _selectTab(tab);  
    });

    //extract the duration from the index
    recoveryDuration = new ValueNotifier(getExcercises().value[widget.excerciseID].recoveryPeriod);
    recoveryDuration.addListener((){
      print("update the duration on the actual object as well");
    });

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      //vertical page view
      scrollDirection: Axis.vertical,
      //stop users from scroll between things freely
      //physics: NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        /*
        if (_changePageByTapView == false ||
            _changePageByTapView == null) {
          _selectTab(index);
        }
        if (_selectedIndex == index) {
          _changePageByTapView = null;
        }
        
        setState(() {});
        */
      },
      controller: pageController,
      children: <Widget>[
        Suggestion(

        ),
        SetRecord(

        ),
        Break(
          recoveryDuration: recoveryDuration,
        ),
      ],
    );
  }

  void _selectTab(index) {
    print("selected tab: " + index.toString());
    _selectedIndex = index;
    for (AnimationController animationController in animationControllers) {
      animationController.reset();
    }
    animationControllers[index].forward();
  }
}

/*
onTap: () {
                            _changePageByTapView = true;
                            setState(() {
                              _selectTab(index);
                            });

                            pageController.animateToPage(index,
                                duration: widget.changePageDuration,
                                curve: widget.changePageCurve);
                          },
*/