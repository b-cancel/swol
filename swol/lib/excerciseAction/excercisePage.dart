//flutter
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

//plugin
import 'package:page_transition/page_transition.dart';
import 'package:swol/excerciseAction/controllersToWidgets.dart';
import 'package:swol/shared/methods/theme.dart';

//internal: excercise
import 'package:swol/shared/widgets/simple/heros/leading.dart';
import 'package:swol/shared/widgets/simple/heros/title.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//internal
import 'package:swol/excerciseAction/tabs/verticalTabs.dart';
import 'package:swol/pages/notes/excerciseNotes.dart';
import 'package:swol/main.dart';

//TODO: make sure that wehn we start the timer it also sets tempweight and tempreps
//TODO: make sure that when we have tempweight and tempreps they are read into the controllers
//TODO: make sure we are properly reverting back to the expected values
//TODO: make sure that we refocus on the problematic field

//widgets
class ExcercisePage extends StatefulWidget {
  ExcercisePage({
    @required this.excercise,
  });

  final AnExcercise excercise;

  @override
  _ExcercisePageState createState() => _ExcercisePageState();
}

class _ExcercisePageState extends State<ExcercisePage> {
  final ValueNotifier<int> pageNumber = new ValueNotifier<int>(0);

  //weight
  final TextEditingController weightController = new TextEditingController();
  final FocusNode weightFocusNode = new FocusNode();

  //reps
  final TextEditingController repsController = new TextEditingController();
  final FocusNode repsFocusNode = new FocusNode();

  //init
  @override
  void initState() {
    //super init
    super.initState();

    //fill controller vars with temp vars if we have them
    weightController.text = widget.excercise?.tempWeight?.toString() ?? "";
    repsController.text = widget.excercise?.tempReps?.toString() ?? "";
  }

  //dispose
  @override
  void dispose() {
    //dispose no longer needed controllers
    weightController.dispose();
    repsController.dispose();

    //super dispose
    super.dispose();
  }

  //build
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MyTheme.dark,
      child: ExcercisePageDark(
        pageNumber: pageNumber,
        excercise: widget.excercise,
        weightController: weightController,
        weightFocusNode: weightFocusNode,
        repsController: repsController,
        repsFocusNode: repsFocusNode,
        noWarning: noWarning,
        focusOnFirstInValid: focusOnFirstInValid,
      ),
    );
  }

  //if both are valid nothing happens
  focusOnFirstInValid(){
    if(pageNumber.value == 1){
      //grab weight stuff
      bool weightEmpty = weightController.text == "";
      bool weightZero = weightController.text == "0";
      bool weightInvalid = weightEmpty || weightZero;

      //maybe focus on weight
      if(weightInvalid){
        FocusScope.of(context).requestFocus(weightFocusNode);
      }
      else{
        //grab reps stuff
        bool repsEmtpy = repsController.text == "";
        bool repsZero = repsController.text == "0";
        bool repsInvalid = repsEmtpy || repsZero;

        //maybe focus on reps
        if(repsInvalid){
          FocusScope.of(context).requestFocus(repsFocusNode);
        }
      }
    }
  }

  //determine whether we should warn the user
  noWarning({bool alsoPop: false}) {
    DateTime startTime = widget.excercise.tempStartTime.value;
    bool timerNotStarted = (startTime == AnExcercise.nullDateTime);

    //if the timer hasn't yet started we may need to bring up the pop up
    if (timerNotStarted) {
      //check for data validity
      bool weightValid = weightController.text != "";
      weightValid &= weightController.text != "0";
      bool repsValid = repsController.text != "";
      repsValid &= repsController.text != "0";

      //since this isthe warning we only care of atleast one if filled
      //else we assume a misclick
      if (weightValid || repsValid) {
        //NOTE: this assumes the user CANT type anything except digits of the right size
        bool setValid = weightValid && repsValid;

        //bring up pop up
        AwesomeDialog(
          context: context,
          isDense: false,
          dismissOnTouchOutside: true,
          dialogType: DialogType.WARNING,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          body: Column(
            children: [
              Text(
                "Begin Your Set Break",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              Text(
                "to avoid losing your set",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 16,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      weightAndRepsToDescription(
                        weightController.text,
                        repsController.text,
                      ),
                      weightAndRepsToProblem(
                        weightValid, 
                        repsValid,
                      ),
                      Visibility(
                        visible: setValid == false,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: "If you don't ",
                              ),
                              TextSpan(
                                text: "Fix Your Set",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ", this information will be lost. ",
                              ),
                              TextSpan(
                                text: "Would you like to ",
                              ),
                              TextSpan(
                                text: "Go Back",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " and Fix Your Set?",
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: setValid,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: "But if you don't ",
                              ),
                              TextSpan(
                                text: "Begin Your Set Break",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ", this set will be lost. ",
                              ),
                              TextSpan(
                                text: "Would you like to ",
                              ),
                              TextSpan(
                                text: "Go Back",
                                style: TextStyle( 
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " and Begin Your Set Break?",
                              ),
                            ],
                          ),
                        ),
                      ),
                      //-------------------------Reps-------------------------
                      Transform.translate(
                        offset: Offset(0, 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                goBack(true);
                              },
                              child: Text(
                                "No, Delete The Set",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            RaisedButton(
                              color: Colors.blue,
                              //TODO: focus on the first field that is messed up
                              onPressed: (){
                                //pop ourselves
                                Navigator.of(context).pop();

                                //move onto next invalid
                                focusOnFirstInValid();
                              },
                              child: Text(
                                "Yes, Go Back",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ).show();

        //don't allow popping automatically
        return false;
      } else {
        goBack(alsoPop);
        return true;
      }
    } else {
      goBack(alsoPop);
      return true;
    }
  }

  goBack(bool alsoPop) {
    //may have to unfocus
    FocusScope.of(context).unfocus();
    //animate the header
    App.navSpread.value = false;
    //pop if not using the back button
    if (alsoPop) Navigator.of(context).pop();
  }
}

class ExcercisePageDark extends StatelessWidget {
  ExcercisePageDark({
    @required this.pageNumber,
    @required this.excercise,
    @required this.weightController,
    @required this.weightFocusNode,
    @required this.repsController,
    @required this.repsFocusNode,
    @required this.noWarning,
    @required this.focusOnFirstInValid,
  });

  final ValueNotifier<int> pageNumber;
  final AnExcercise excercise;
  final TextEditingController weightController;
  final FocusNode weightFocusNode;
  final TextEditingController repsController;
  final FocusNode repsFocusNode;
  final Function noWarning;
  final Function focusOnFirstInValid;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => noWarning(),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: SafeArea(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                          left: 0,
                          bottom: 0,
                          top: 0,
                          right: 0,
                          child: ExcerciseTitleHero(
                            inAppBar: true,
                            excercise: excercise,
                            onTap: () => toNotes(context),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: IconButton(
                              icon: ExcerciseBegin(
                                inAppBar: true,
                                excercise: excercise,
                              ),
                              color: Theme.of(context).iconTheme.color,
                              tooltip: MaterialLocalizations.of(context)
                                  .backButtonTooltip,
                              onPressed: () => noWarning(alsoPop: true),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: OutlineButton.icon(
                              highlightedBorderColor:
                                  Theme.of(context).accentColor,
                              onPressed: () {
                                toNotes(context);
                              },
                              icon: Icon(Icons.edit),
                              label: Text("Notes"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: VerticalTabs(
          pageNumber: pageNumber,
          excercise: excercise,
          statusBarHeight: MediaQuery.of(context).padding.top,
          weightController: weightController,
          weightFocusNode: weightFocusNode,
          repsController: repsController,
          repsFocusNode: repsFocusNode,
          focusOnFirstInValid: focusOnFirstInValid,
        ),
      ),
    );
  }

  //called when going to notes
  toNotes(BuildContext context) {
    //close keyboard if perhaps typing next set
    FocusScope.of(context).unfocus();

    //go to notes
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        duration: Duration(milliseconds: 300),
        child: ExcerciseNotes(
          excercise: excercise,
        ),
      ),
    );
  }
}
