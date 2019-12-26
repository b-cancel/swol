//flutter
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//plugins
import 'package:direct_select_flutter/direct_select_container.dart';

//internal
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/excerciseAddition/secondary/save.dart';
import 'package:swol/excerciseAddition/secondary/sections.dart';
import 'package:swol/excerciseSelection/secondary/addNewHero.dart';
import 'package:swol/sharedWidgets/basicFields/excerciseEdit.dart';
import 'package:swol/other/functions/helper.dart';

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
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Card(
                          margin: EdgeInsets.all(8),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 8,
                              left: 16,
                              right: 16,
                              bottom: 16,
                            ),
                            child: BasicEditor(
                              namePresent: namePresent,
                              nameError: nameError,
                              name: name,
                              note: note,
                              url: url,
                            ),
                          ),
                        ),
                        RecoveryTimeCard(
                          changeDuration: changeDuration, 
                          sliderWidth: sliderWidth, 
                          //value notifier below
                          recoveryPeriod: recoveryPeriod, 
                        ),
                        SetTargetCard(
                          setTarget: setTarget,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            RepTargetCard(
                              changeDuration: changeDuration, 
                              sliderWidth: sliderWidth, 
                              repTargetDuration: repTargetDuration, 
                              repTarget: repTarget,
                            ),
                            FunctionSelection(
                              functionIndex: functionIndex, 
                              functionString: functionString,
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: 56.0 + 16,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).accentColor,
                    onPressed: (){
                      print("go to explain page");
                    },
                    tooltip: "What is all this stuff? (o_O)",
                    child: Icon(FontAwesomeIcons.question),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}