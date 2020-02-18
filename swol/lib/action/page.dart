//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:page_transition/page_transition.dart';
import 'package:swol/shared/functions/defaultDateTimes.dart';
import 'package:swol/shared/methods/theme.dart';

//internal: excercise
import 'package:swol/shared/widgets/simple/heros/leading.dart';
import 'package:swol/shared/widgets/simple/heros/title.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//internal
import 'package:swol/pages/notes/excerciseNotes.dart';
import 'package:swol/action/tabs/verticalTabs.dart';
import 'package:swol/action/popUps/warning.dart';

//used to 
//1. keep track of all the variables and be able to access them from everywhere
//2. and generate the functions to show the warning when needed
//3. but also wrap the rest of the widgets in the dark theme
class ExcercisePage extends StatelessWidget {
  ExcercisePage({
    @required this.excercise,
  });

  final AnExcercise excercise;

  //static vars used through out initializaed with their default values

  //used so that we can change the page number from anywhere
  static final ValueNotifier<int> pageNumber = new ValueNotifier<int>(0);
  //used so that we can set the goal set from both the suggest and record page
  static final ValueNotifier<int> setGoalWeight = new ValueNotifier<int>(0);
  static final ValueNotifier<int> setGoalReps = new ValueNotifier<int>(0);
  //used so that we can save the set locally before saving it in temps
  static final ValueNotifier<String> setWeight = new ValueNotifier<String>("");
  static final ValueNotifier<String> setReps = new ValueNotifier<String>("");
  //used so that we can cause a field refocusing from different parts of the app
  static final ValueNotifier<bool> causeRefocusIfInvalid = new ValueNotifier<bool>(false);
  //function trigger that can be accessed from nearly anywhere
  static final ValueNotifier<bool> updateSet = new ValueNotifier<bool>(false);
  static final ValueNotifier<bool> nextSet = new ValueNotifier<bool>(false);

  //build
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MyTheme.dark,
      child: WillPopScope(
        onWillPop: () async{
          return warningThenAllowPop(
            context, 
            excercise,
            //false since return true here will pop
            alsoPop: false,
          );
        },
        child: ExcercisePageDark(
          excercise: excercise,
        ),
      ),
    );
  }
}

class ExcercisePageDark extends StatefulWidget {
  ExcercisePageDark({
    @required this.excercise,
  });

  final AnExcercise excercise;

  @override
  _ExcercisePageDarkState createState() => _ExcercisePageDarkState();
}

class _ExcercisePageDarkState extends State<ExcercisePageDark> {
  updateSet(){ //also cover resume case
    if(ExcercisePage.updateSet.value){
      //whenever we begin or resume the set we KNOW our setWeight and setReps are valid
      String setWeight = ExcercisePage.setWeight.value;
      String setReps = ExcercisePage.setReps.value;
      widget.excercise.tempWeight = int.parse(setWeight);
      widget.excercise.tempReps = int.parse(setReps);
    
      //only if begin
      if(widget.excercise.tempStartTime.value == AnExcercise.nullDateTime){
        //start the timer
        widget.excercise.tempStartTime = ValueNotifier<DateTime>(DateTime.now()); 

        //indicate you have started the set
        widget.excercise.tempSetCount = ValueNotifier<int>(
          widget.excercise.tempSetCount.value + 1,
        );

        //we are recording our FIRST set so may go back to it 
        //if we delete it instead of deciding to continue
        if(widget.excercise.tempSetCount.value == 1){ 
          widget.excercise.backUpTimeStamp = widget.excercise.lastTimeStamp.value;
        }
        //set in progress time stamp
        widget.excercise.lastTimeStamp = ValueNotifier<DateTime>(LastTimeStamp.inProgressDateTime());
      }

      //action complete
      ExcercisePage.updateSet.value = false;
    }
  }

  nextSet(){
    if(ExcercisePage.nextSet.value){
      //reset timer (MUST HAPPEN FIRST)
      widget.excercise.tempStartTime = ValueNotifier<DateTime>(AnExcercise.nullDateTime);

      //when we end set we KNOW our tempWeight and tempReps are valid 

      //handle weight (we KNOW its VALID)
      widget.excercise.lastWeight = widget.excercise.tempWeight;
      widget.excercise.tempWeight = null;
      ExcercisePage.setWeight.value = "";

      //handle reps (we KNOW its VALID)
      widget.excercise.lastReps = widget.excercise.tempReps;
      widget.excercise.tempReps = null;
      ExcercisePage.setReps.value = "";

      //action complete
      ExcercisePage.nextSet.value = false;      
    }
  }

  @override
  void initState() {
    //super init
    super.initState();
    
    //reset all statics to defaults
    ExcercisePage.pageNumber.value = 0; //this will properly update itself later
    //goals
    ExcercisePage.setGoalWeight.value = 0;
    ExcercisePage.setGoalReps.value = 0;
    //notifiers
    ExcercisePage.setWeight.value = "";
    ExcercisePage.setReps.value = "";
    //functions
    ExcercisePage.causeRefocusIfInvalid.value = false;
    ExcercisePage.updateSet.value = false;
    ExcercisePage.nextSet.value = false;

    //add listeners
    ExcercisePage.updateSet.addListener(updateSet);
    ExcercisePage.nextSet.addListener(nextSet);
  }

  @override
  void dispose() { 
    //remove listeners
    ExcercisePage.updateSet.removeListener(updateSet);
    ExcercisePage.nextSet.removeListener(nextSet);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: SafeArea(
            child: Theme(
              data: MyTheme.light,
              child: PageTitle(
                excercise: widget.excercise,
              ),
            ),
          ),
        ),
      ),
      body: ClipRRect( //clipping so the done button doesnt show out of screen
        child: VerticalTabs(
          excercise: widget.excercise,
          //this the only place this works from
          //since this is the whole new context after navigation 
          //and the others are within a scaffold
          statusBarHeight: MediaQuery.of(context).padding.top,
        ),
      ),
    );
  }
}

class PageTitle extends StatelessWidget {
  PageTitle({
    @required this.excercise,
  });

  final AnExcercise excercise;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MyTheme.dark,
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
                color: Colors.white,
                tooltip: backToolTip(),
                onPressed: (){
                  warningThenAllowPop(
                    context, 
                    excercise, 
                    alsoPop: true,
                  );
                },
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
                onPressed: () => toNotes(context),
                icon: Icon(Icons.edit),
                label: Text("Notes"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String backToolTip(){
    return "Will Automaticaly Start Or Update Your New Set";
  }

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