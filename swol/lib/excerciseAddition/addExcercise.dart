//flutter
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//plugins
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:swol/excerciseAddition/popUps/popUpFunctions.dart';

//internal from addition
import 'package:swol/excerciseAddition/secondary/sections/predictionFunction.dart';
import 'package:swol/excerciseAddition/secondary/sections/recoveryTime.dart';
import 'package:swol/excerciseAddition/secondary/sections/repTarget.dart';
import 'package:swol/excerciseAddition/secondary/sections/setTarget.dart';
import 'package:swol/excerciseAddition/secondary/save.dart';

//internal other
import 'package:swol/excerciseSelection/secondary/addNewHero.dart';
import 'package:swol/sharedWidgets/basicFields/clearableTextField.dart';
import 'package:swol/sharedWidgets/basicFields/excerciseEdit.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/other/functions/helper.dart';
import 'package:swol/sharedWidgets/basicFields/referenceLink.dart';
import 'package:swol/sharedWidgets/informationDisplay.dart';

//TODO: when the user comes in here for the first time automatically open the question mark pop up
//TODO: this pop up should morph graphfully from the question mark into the pop up
//TODO: ofcourse this should be openable afterwards but only comes up automatically the first time

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
class AddExcercise extends StatelessWidget {
  AddExcercise({
    Key key,
    @required this.navSpread,
  }) : super(key: key);

  final ValueNotifier<bool> navSpread;

  //-----all the variables used below but not passed
  final ValueNotifier<bool> showSaveButton = new ValueNotifier(false);

  //basics
  final ValueNotifier<bool> namePresent = new ValueNotifier(false);
  final ValueNotifier<bool> nameError = new ValueNotifier(false);
  final ValueNotifier<String> name = new ValueNotifier("");
  final ValueNotifier<String> note = new ValueNotifier("");
  final ValueNotifier<String> url = new ValueNotifier("");

  //function select
  final ValueNotifier<int> functionIndex = new ValueNotifier(AnExcercise.defaultFunctionID);
  final ValueNotifier<String> functionString = new ValueNotifier(
    Functions.functions[AnExcercise.defaultFunctionID],
  );

  //recovery period select
  final ValueNotifier<Duration> recoveryPeriod = new ValueNotifier(
    AnExcercise.defaultRecovery,
  );

  //set target select
  final ValueNotifier<int> setTarget = new ValueNotifier(
    AnExcercise.defaultSetTarget,
  );

  //rep target select
  final ValueNotifier<int> repTarget = new ValueNotifier(
    AnExcercise.defaultRepTarget,
  );

  //updated the above
  final ValueNotifier<Duration> repTargetDuration = new ValueNotifier(
    Duration(
      seconds: AnExcercise.defaultRepTarget * 5,
    )
  );

  final FocusNode noteFocusNode = FocusNode();

  //build
  @override
  Widget build(BuildContext context) {
    //let the button animate in after the add excercise page slides in
    Future.delayed(Duration(milliseconds: 500), (){
      showSaveButton.value = true;
    });

    //update duration so our ticks update
    repTarget.addListener((){
      repTargetDuration.value = Duration(
        seconds: repTarget.value * 5,
      );
    });

    //for slider hatch mark
    double totalWidth = MediaQuery.of(context).size.width;
    double sliderWidth = totalWidth - (16.0 * 2) - (8 * 2);

    //how long it takes to shift focus to a different section
    Duration changeDuration = Duration(milliseconds: 250);

    //each section
    List<Widget> sections = [
      Theme(
        data: ThemeData.light(),
        child: NameCard(
          name: name, 
          nameError: nameError, 
          namePresent: namePresent, 
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
          changeDuration: changeDuration, 
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
          changeDuration: changeDuration, 
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
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      top: 0,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                          ),
                          child: SaveButton(
                            navSpread: navSpread, 
                            showSaveButton: showSaveButton, 
                            nameError: nameError,
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
                        delay: Duration(
                          //after the page slides in
                          milliseconds: 500,
                        ),
                        duration: Duration(
                          milliseconds: 350,
                        ),
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

class NameCard extends StatelessWidget {
  const NameCard({
    Key key,
    @required this.name,
    @required this.nameError,
    @required this.namePresent,
    @required this.noteFocusNode,
  }) : super(key: key);

  final ValueNotifier<String> name;
  final ValueNotifier<bool> nameError;
  final ValueNotifier<bool> namePresent;
  final FocusNode noteFocusNode;

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          HeaderWithInfo(
            title: "Name",
            popUpFunction: () => excerciseNamePopUp(context),
          ),
          TextFieldWithClearButton(
            editOneAtAtTime: false,
            valueToUpdate: name,
            hint: "Required*", 
            error: (nameError.value) ? "Name Is Required" : null, 
            //auto focus field
            autofocus: true,
            //we need to keep track above to determine whether we can active the button
            present: namePresent, 
            //so next focuses on the note
            otherFocusNode: noteFocusNode,
          ),
        ],
      ),
    );
  }
}

class NotesCard extends StatelessWidget {
  const NotesCard({
    Key key,
    @required this.note,
    @required this.noteFocusNode,
  }) : super(key: key);

  final ValueNotifier<String> note;
  final FocusNode noteFocusNode;

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          HeaderWithInfo(
            title: "Notes",
            popUpFunction: () => excerciseNotePopUp(context),
          ),
          TextFieldWithClearButton(
            editOneAtAtTime: false,
            valueToUpdate: note,
            hint: "Details", 
            error: null, 
            //so we can link up both fields
            focusNode: noteFocusNode,
          ),
        ],
      ),
    );
  }
}

class LinkCard extends StatelessWidget {
  const LinkCard({
    Key key,
    @required this.url,
  }) : super(key: key);

  final ValueNotifier<String> url;

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: HeaderWithInfo(
              title: "Reference Link",
              popUpFunction: () => referenceLinkPopUp(context),
            ),
          ),
          ReferenceLinkBox(
            url: url,
            editOneAtAtTime: false,
          ),
        ],
      ),
    );
  }
}

class BasicCard extends StatelessWidget {
  const BasicCard({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Card(
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}