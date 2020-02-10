//flutter
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

//plugin
import 'package:page_transition/page_transition.dart';
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
  final TextEditingController repController = new TextEditingController();

  //init
  @override
  void initState() {
    //super init
    super.initState();

    //fill controller vars with temp vars if we have them
    weightController.text = widget.excercise?.tempWeight?.toString() ?? "";
    repController.text = widget.excercise?.tempReps?.toString() ?? "";
  }

  //dispose
  @override
  void dispose() {
    //dispose no longer needed controllers
    weightController.dispose();
    repController.dispose();

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
        repController: repController,
        noWarning: noWarning,
      ),
    );
  }

  //determine whether we should warn the user
  noWarning({bool alsoPop: false}){
    bool warningWaranted = true;
    if(warningWaranted){
      //todo show pop up that will either just go back to this page
      //todo or confirm the loss of data
      AwesomeDialog(
        context: context,
        isDense: true,
        dismissOnTouchOutside: true,
        dialogType: DialogType.WARNING,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        body: Container(
          child: Text("naw bruh"),
        )
      ).show();
    }
    else{
      //may have to unfocus
      FocusScope.of(context).unfocus();
      //animate the header
      App.navSpread.value = false;
      //pop if not using the back button
      if(alsoPop) Navigator.of(context).pop();
    }

    //for the function that requires you to allow poping
    //if warning was not needed than the system can auto pop
    //else the pop up will do so
    return warningWaranted == false;
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
                              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
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
                              highlightedBorderColor: Theme.of(context).accentColor,
                              onPressed: (){
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
  toNotes(BuildContext context){
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