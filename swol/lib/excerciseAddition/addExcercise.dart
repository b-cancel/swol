//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:direct_select_flutter/direct_select_container.dart';

//internal: addition
import 'package:swol/excerciseAddition/secondary/sections/recoveryTime.dart';
import 'package:swol/excerciseAddition/matchTrainingTypeTip.dart';
import 'package:swol/excerciseAddition/reloadingCard.dart';
import 'package:swol/excerciseAddition/save.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/fields/fields/setTarget/setTarget.dart';
import 'package:swol/shared/widgets/complex/fields/fields/text/notesField.dart';
import 'package:swol/shared/widgets/complex/fields/fields/linkField/link.dart';
import 'package:swol/shared/widgets/complex/fields/fields/text/nameField.dart';
import 'package:swol/shared/widgets/complex/fields/fields/repTarget.dart';
import 'package:swol/shared/widgets/complex/fields/fields/function.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//internal: other
import 'package:swol/excerciseSelection/secondary/addNewHero.dart';
import 'package:swol/other/functions/helper.dart';
import 'package:swol/main.dart';

//TODO *IMPROVEMENT*: remove strange extra padding on top of name
//TODO *IMPROVEMENT*: swiping left and right on the 3 settings make the value go up and down
//TODO *IMPROVEMENT*: improve the set target UI that looks funky but idk why
//TODO *IMPROVEMENT*: make the set target training type buttons match the others more
//TODO *IMPROVEMENT*: prediction formula special hold and let go to select UI

//when we have animated "to learn section" hyperlinks 
//TODO *IMPROVEMENT*: whenever exiting this page NOT manually we should save all of the data in a file
//TODO *IMPROVEMENT*: so whenever we open up this page we automatically ask the user if they would like to load up the previous data
//or perhaps we could yolo it and load it up cuz it really isnt that much hassle to clear out the fields anyways
//once the data is loaded in so that we are restoring an add workout session... 
//after having traveled away into the learn section we wipe the file ofcourse

//888-568-0296: USAA

//main widget
class AddExcercise extends StatelessWidget {
  AddExcercise({
    Key key,

    //NOTE: 200 ms above the norm so they can see the sweat animation
    this.showPageDuration: const Duration(milliseconds: 500),
    this.showListDuration: const Duration(milliseconds: 350),
    this.showSaveDuration: const Duration(milliseconds: 350),

    //this delay plays AFTER the page completely shows
    this.delayBetweenListItems: const Duration(milliseconds: 500),
    this.delayBeforeSaveShow: const Duration(milliseconds: 450),

    this.sectionTransitionDuration: const Duration(milliseconds: 250),
  }) : super(key: key);

  final Duration showPageDuration;
  final Duration showListDuration;
  final Duration showSaveDuration;

  //this delay plays AFTER the page completely shows
  final Duration delayBetweenListItems;
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

  final ValueNotifier<int> functionIndex = new ValueNotifier(
    AnExcercise.defaultFunctionID,
  );
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

  final ValueNotifier<bool> tipIsShowing = new ValueNotifier(false);

  //-------------------------Focus Nodes-------------------------
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode noteFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    //each section
    List<Widget> sections = [
      BasicCard(
        notifier: nameError,
        child: NameField(
          nameToUpdate: name, 
          showError: nameError, 
          namePresent: namePresent, 
          nameFocusNode: nameFocusNode,
          noteFocusNode: noteFocusNode,
          autofocus: false,
        ),
      ),
      BasicCard(
        child: NotesField(
          noteToUpdate: note,
          noteFocusNode: noteFocusNode,
        ),
      ),
      BasicCard(
        notifier: url,
        child: LinkField(url: url),
      ),
      RecoveryTimeCard(
        changeDuration: sectionTransitionDuration,
        recoveryPeriod: recoveryPeriod, 
      ),
      SetTargetCard(
        setTarget: setTarget,
      ),
      RepTargetField(
        changeDuration: sectionTransitionDuration,
        repTarget: repTarget,
      ),
      BasicCard(
        child: PredictionField(
          functionIndex: functionIndex, 
          functionString: functionString,
        ),
      ),
      TipSpacing(
        tipIsShowing: tipIsShowing,
      ),
    ];

    //build
    return WillPopScope(
      onWillPop: ()async{
        FocusScope.of(context).unfocus();
        App.navSpread.value = false;
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
                          delay: showPageDuration + delayBeforeSaveShow,
                          showSaveButton: showSaveButton, 
                          nameFocusNode: nameFocusNode,
                          nameError: nameError,
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
                    TipGenerator(
                      tipIsShowing: tipIsShowing,
                      recoveryPeriod: recoveryPeriod,
                      setTarget: setTarget,
                      repTarget: repTarget,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        //TODO: the widget below isn't doing anything unless I use that one plugin
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
                        delay: (delayBetweenListItems),
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