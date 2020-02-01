//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:scroll_to_index/scroll_to_index.dart';

//internal: excercise selection
import 'package:swol/excerciseSelection/widgets/animatedTitle.dart';
import 'package:swol/excerciseSelection/widgets/bottomButtons.dart';
import 'package:swol/excerciseSelection/excerciseList.dart';
import 'package:swol/excerciseSelection/uela.dart';

//internal: shared
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'package:swol/shared/functions/onboarding.dart';
import 'package:swol/shared/widgets/simple/scrollToTop.dart';

//Sections and how they are handled
//New => newest additions on bottom
//  since you would probably add your new routine and then work it
///TODO: ensure this exception
//Hidden => newest addition on top [EXCEPTION]
//  since the excercises you most recently archived are the ones most likely to be searched for again
//In Progress => newest additions on bottom
//  since we want to push people to doing super sets with atmost like 3 workouts
//  and while doing super sets you are doing set 1 A, then set 1 B, then set 1 C
//  and you would expect the user to go back to 1A before goign to 1B or 1C so 1A should be on top
//Other => newest additions on the bottom
//  since you want to cycle throughout all your workout routines
//  so if you did legs on monday and 3 other work outs
//  when its monday again you expect that workout to be on top with the first workout you did to be on top in the section

//TODO: when the user open the app and there is ONLY 1 excercise in progress
//TODO: automatically go to that excercse (ensure animation)

//main widget
class ExcerciseSelect extends StatefulWidget {
  @override
  _ExcerciseSelectState createState() => _ExcerciseSelectState();
}

class _ExcerciseSelectState extends State<ExcerciseSelect> {
  final AutoScrollController autoScrollController = new AutoScrollController();
  final ValueNotifier<bool> onTop = new ValueNotifier(true);

  updateOnTopValue(){
    ScrollPosition position = autoScrollController.position;
    double currentOffset = autoScrollController.offset;

    //Determine whether we are on the top of the scroll area
    if (currentOffset <= position.minScrollExtent){
      onTop.value = true;
    }
    else onTop.value = false;
  }

  @override
  void initState() { 
    //create function to be called after the user accept the uela
    Function maybeShowInitialControls = (){
      if(SharedPrefsExt.getInitialControlsShown().value == false){
        OnBoarding.discoverSwolLogo(context);
      }
    };

    //ask for permission after the frame loads
    WidgetsBinding.instance.addPostFrameCallback((_){
      //pop up that comes up asking for permission
      if(SharedPrefsExt.getTermAgreed().value == false){
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return UELA(
              afterConfirm: () => maybeShowInitialControls(),
            );
          },
        );
      } 
      else maybeShowInitialControls();
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
          /*
          IconButton(
            onPressed: (){
              showThemeSwitcher(context);
            },
            icon: Icon(Icons.settings),
          )
          */
          AnimatedTitleAction(
            screenWidth: screenWidth,
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Stack(
          children: <Widget>[
            //the list or lack of excercises
            //and the search button under certain conditions
            ExcerciseList(
              autoScrollController: autoScrollController,
              statusBarHeight: statusBarHeight,
              onTop: onTop,
            ),
            ScrollToTopButton(
              onTop: onTop,
              autoScrollController: autoScrollController,
            ),
            //Add New Excercise Button
            AddExcerciseButton(),
            /*
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: RaisedButton(
                onPressed: (){
                  showThemeSwitcher(context);
                },
                child: Text("meep"),
              ),
            )
            */
          ],
        ),
      ),
    );
  }
}