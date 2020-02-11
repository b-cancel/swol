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
  //the two controllers we use to determine wether to warn the user
  //that they might want to begin their set break or risk losing their plugged in values
  final TextEditingController weightController = new TextEditingController();
  final TextEditingController repsController = new TextEditingController();

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
        excercise: widget.excercise,
        weightController: weightController,
        repController: repsController,
        noWarning: noWarning,
      ),
    );
  }

  //determine whether we should warn the user
  noWarning({bool alsoPop: false}) {
    DateTime startTime = widget.excercise.tempStartTime.value;
    bool timerNotStarted = startTime == AnExcercise.nullDateTime;
    bool weightValid =
        weightController.text != "" && weightController.text != "0";
    bool repsValid = repsController.text != "" && repsController.text != "0";
    bool weightOrRepsNotEmptyOrZero = weightValid || repsValid;
    bool warningWaranted = timerNotStarted && weightOrRepsNotEmptyOrZero;

    //bring up the pop up if needed
    if (warningWaranted) {
      //NOTE: this assumes the user CANT type anything except digits of the right size
      bool setValid = weightValid && repsValid;

      //show the dialog
      AwesomeDialog(
        context: context,
        isDense: true,
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
                    weightAndRepsToWidget(
                        weightController.text, repsController.text),
                    Visibility(
                      visible: setValid == false,
                      //TODO: add set warning or aid
                      //IF reps is 0 then it should be recorded as a set
                      //IF weight is 0 then assume you are talking about body weight excercises and tell them to use their body weight
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Visibility(
                            visible: weightValid == false,
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        "But for body weight excercises you should instead ",
                                  ),
                                  TextSpan(
                                    text: "record your body weight\n",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: repsValid == false,
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        "But a set consists of lifting a weight ",
                                  ),
                                  TextSpan(
                                    text: "atleast once\n",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          RichText(
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
                                  text: " this information will be lost. ",
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
                        ],
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
                              text: " this set will be lost. ",
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
                            onPressed: () => Navigator.of(context).pop(),
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
    } else
      goBack(alsoPop);

    //for the function that requires you to allow poping
    //if warning was not needed than the system can auto pop
    //else the pop up will do so
    return warningWaranted == false;
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
    @required this.excercise,
    @required this.weightController,
    @required this.repController,
    @required this.noWarning,
  });

  final AnExcercise excercise;
  final TextEditingController weightController;
  final TextEditingController repController;
  final Function noWarning;

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
          excercise: excercise,
          statusBarHeight: MediaQuery.of(context).padding.top,
          weightController: weightController,
          repController: repController,
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
