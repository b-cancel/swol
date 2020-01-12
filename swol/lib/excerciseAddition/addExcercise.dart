//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:swol/excerciseAddition/addExcerciseBasicCards.dart';

//internal from addition
import 'package:swol/excerciseAddition/secondary/sections/predictionFunction.dart';
import 'package:swol/excerciseAddition/secondary/sections/recoveryTime.dart';
import 'package:swol/excerciseAddition/secondary/sections/repTarget.dart';
import 'package:swol/excerciseAddition/secondary/sections/setTarget.dart';
import 'package:swol/excerciseAddition/secondary/save.dart';

//internal other
import 'package:swol/excerciseSelection/secondary/addNewHero.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/other/functions/helper.dart';

/*
TODO 

at all times we are trying to help the user
every user is going to get the best results by focusing on 1 of the 3 types of training 
so we help them do that

When any mismatch
"In order to get the fastest results, you should use the suggested"
"Eecovery Time, Set target, and Rep target"
"for ONE type of training"

When all mismatch
"To Get Strong use Strength Training"
"To Get Big use Hypertrophy Training"
"To Get Agile use Endurance Training"

When 1 mismatch
"To make them all match change the XXX value to be within YYY Training Range"
*/

//TODO: when we have animated "to learn section" hyperlinks 
//TODO: whenever exiting this page NOT manually we should save all of the data in a file
//TODO: so whenever we open up this page we automatically ask the user if they would like to load up the previous data
//TODO: or perhaps we could yolo it and load it up cuz it really isnt that much hassle to clear out the fields anyways
//TODO: once the data is loaded in so that we are restoring an add workout session... 
//TODO:   after having traveled away into the learn section we wipe the file ofcourse

/*
when tapping 
1. all header jazz
2. all training type pop ups
*/

//main widget
//NOTE: we should not rebuild this whole widget
//there is simply too much to rebuild
//instead rebuild the subwidgets
class AddExcercise extends StatelessWidget {
  AddExcercise({
    Key key,
    @required this.navSpread,
    @required this.shownSaveVN,

    //NOTE: 200 ms above the norm so they can see the sweat animation
    this.showPageDuration: const Duration(milliseconds: 500),
    this.showListDuration: const Duration(milliseconds: 350),
    this.showSaveDuration: const Duration(milliseconds: 350),

    //this delay plays AFTER the page completely shows
    this.delayBeforeListShow: const Duration(milliseconds: 250),
    this.delayBeforeSaveShow: const Duration(milliseconds: 450),

    this.sectionTransitionDuration: const Duration(milliseconds: 250),
  }) : super(key: key);

  final ValueNotifier<bool> navSpread;
  final ValueNotifier<bool> shownSaveVN;

  final Duration showPageDuration;
  final Duration showListDuration;
  final Duration showSaveDuration;

  //this delay plays AFTER the page completely shows
  final Duration delayBeforeListShow;
  final Duration delayBeforeSaveShow;

  final Duration sectionTransitionDuration;

  //-------------------------extra variables
  final ValueNotifier<bool> showSaveButton = new ValueNotifier(false);
  final ValueNotifier<bool> namePresent = new ValueNotifier(false);
  final ValueNotifier<bool> nameError = new ValueNotifier(false);

  //-------------------------excercise variables-------------------------
  final ValueNotifier<String> name = new ValueNotifier("");
  final ValueNotifier<String> note = new ValueNotifier("");
  final ValueNotifier<String> url = new ValueNotifier("");

  final ValueNotifier<int> functionIndex = new ValueNotifier(AnExcercise.defaultFunctionID);
  final ValueNotifier<String> functionString = new ValueNotifier(
    Functions.functions[AnExcercise.defaultFunctionID],
  );

  final ValueNotifier<Duration> recoveryPeriod = new ValueNotifier(
    AnExcercise.defaultRecovery,
  );

  final ValueNotifier<int> setTarget = new ValueNotifier(
    AnExcercise.defaultSetTarget,
  );

  final ValueNotifier<int> repTarget = new ValueNotifier(
    AnExcercise.defaultRepTarget,
  );
  final ValueNotifier<Duration> repTargetDuration = new ValueNotifier(
    Duration(
      seconds: AnExcercise.defaultRepTarget * 5,
    )
  );

  //-------------------------Focus Nodes-------------------------
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode noteFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    //for slider hatch mark
    double totalWidth = MediaQuery.of(context).size.width;
    double sliderWidth = totalWidth - (16.0 * 2) - (8 * 2);

    //each section
    List<Widget> sections = [
      Theme(
        data: ThemeData.light(),
        child: NameCard(//
          name: name, 
          nameError: nameError, 
          namePresent: namePresent, 
          nameFocusNode: nameFocusNode,
          noteFocusNode: noteFocusNode,
        ),
      ),
      Theme(
        data: ThemeData.light(),
        child: NotesCard(
          note: note, 
          noteFocusNode: noteFocusNode,
        ),
      ),
      Theme(
        data: ThemeData.light(),
        child: LinkCard(
          url: url,
        ),
      ),
      Theme(
        data: ThemeData.light(),
        child: RecoveryTimeCard(
          changeDuration: sectionTransitionDuration, 
          sliderWidth: sliderWidth, 
          //value notifier below
          recoveryPeriod: recoveryPeriod, 
        ),
      ),
      Theme(
        data: ThemeData.light(),
        child: SetTargetCard(
          setTarget: setTarget,
        ),
      ),
      Theme(
        data: ThemeData.light(),
        child: RepTargetCard(
          changeDuration: sectionTransitionDuration, 
          sliderWidth: sliderWidth, 
          repTargetDuration: repTargetDuration, 
          repTarget: repTarget,
        ),
      ),
      Theme(
        data: ThemeData.light(),
        child: FunctionSelection(
          functionIndex: functionIndex, 
          functionString: functionString,
        ),
      ),
      //TODO: actually use this space by adding a appearing tool tip that gives you suggestions
      //TODO: its not a tool tip in the traditional sense since it doesnt go away
      //TODO; it also changes depending on all the values selected so far
      /*
      Container(
        height: 56.0 + 16,
      ),
      */
    ];

    //build
    return WillPopScope(
      onWillPop: ()async{
        FocusScope.of(context).unfocus();
        navSpread.value = false;
        return true; //can still pop
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: SafeArea(
              child: Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      bottom: 0,
                      top: 0,
                      right: 0,
                      child: AddNewHero(
                        inAppBar: true,
                        navSpread: navSpread,
                        shownSaveVN: shownSaveVN,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 8.0,
                        ),
                        child: SaveButton(
                          navSpread: navSpread, 
                          delay: showPageDuration + delayBeforeSaveShow,
                          showSaveButton: showSaveButton, 
                          nameFocusNode: nameFocusNode,
                          nameError: nameError,
                          shownSaveVN: shownSaveVN,
                          //transition duration
                          showSaveDuration: showSaveDuration,
                          //variables
                          namePresent: namePresent, 
                          name: name, 
                          url: url, 
                          note: note, 
                          functionIndex: functionIndex, 
                          repTarget: repTarget, 
                          recoveryPeriod: recoveryPeriod, 
                          setTarget: setTarget, 
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: DirectSelectContainer(
          child: Stack(
            children: <Widget>[
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: AnimationLimiter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    itemCount: sections.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        //500 (page slide in) + 250 (save button show)
                        delay: (showPageDuration + delayBeforeListShow),
                        duration: showListDuration,
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: sections[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}