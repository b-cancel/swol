//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//internl: exercise
import 'package:swol/shared/widgets/complex/fields/fields/linkField/link.dart';
import 'package:swol/shared/widgets/complex/fields/fields/text/nameField.dart';
import 'package:swol/shared/widgets/complex/fields/fields/text/notesField.dart';
import 'package:swol/shared/widgets/simple/notify.dart';
import 'package:swol/shared/widgets/simple/playOnceGif.dart';
import 'package:swol/shared/functions/defaultDateTimes.dart';
import 'package:swol/shared/methods/exerciseData.dart';
import 'package:swol/shared/structs/anExercise.dart';

//internal: other
import 'package:swol/pages/notes/exerciseMessages.dart';
import 'package:swol/action/page.dart';

class ExerciseNotesStateless extends StatelessWidget {
  ExerciseNotesStateless({
    @required this.exercise,
  });

  final AnExercise exercise;

  static bool inStack = false;

  @override
  Widget build(BuildContext context) {
    return ExerciseNotes(
      exercise: exercise,
    );
  }
}

//widget
class ExerciseNotes extends StatefulWidget {
  ExerciseNotes({
    @required this.exercise,
  });

  final AnExercise exercise;

  @override
  _ExerciseNotesState createState() => _ExerciseNotesState();
}

class _ExerciseNotesState extends State<ExerciseNotes> {
  //basics
  ValueNotifier<bool> nameError = new ValueNotifier(false);
  ValueNotifier<String> name = new ValueNotifier("");
  ValueNotifier<String> note = new ValueNotifier("");
  ValueNotifier<String> url = new ValueNotifier("");

  //listener functions
  updateName() => widget.exercise.name = name.value;
  updateNote() => widget.exercise.note = note.value;
  updateUrl() => widget.exercise.url = url.value;

  //init
  @override
  void initState() { 
    //super init
    super.initState();

    //inform static for notifcation
    ExerciseNotesStateless.inStack = true;

    //set initial values of ValueNotifiers
    name.value = widget.exercise.name;
    note.value = widget.exercise.note;
    url.value = widget.exercise.url;

    //listen to changes
    name.addListener(updateName);
    note.addListener(updateNote);
    url.addListener(updateUrl);
  }

  @override
  void dispose() { 
    //remove listeners
    name.removeListener(updateName);
    note.removeListener(updateNote);
    url.removeListener(updateUrl);

    //inform static for notifcation
    ExerciseNotesStateless.inStack = false;
    
    //super dispose
    super.dispose();
  }

  final FocusNode noteFocusNode = FocusNode();

  goBackToExercisePage(){
    //close any keyboard that may be open
    FocusScope.of(context).unfocus();
    //indicate that we should refocus inf needed
    ExercisePage.causeRefocusIfInvalid.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        goBackToExercisePage();
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: FittedBox(
            fit: BoxFit.contain,
            child: IconButton(
              icon: Icon(Icons.chevron_left),
              color: Theme.of(context).iconTheme.color,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () {
                goBackToExercisePage();
                Navigator.of(context).pop();
              },
            ),
          ),
          title: Text("Notes"),
          actions: [
            BigActionButton(
              exercise: widget.exercise,
              delete: false,
            ),
            BigActionButton(
              exercise: widget.exercise,
              delete: true,
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  NameField(
                    editOneAtATime: true,
                    nameToUpdate: name,
                    showError: nameError,
                    autofocus: true,
                  ),
                  NotesField(
                    editOneAtATime: true,
                    noteToUpdate: note,
                    noteFocusNode: noteFocusNode,
                  ),
                  LinkField(
                    url: url,
                    editOneAtATime: true,
                  ),
                ],
              ), 
            ),
          ],
        ),
      ),
    );
  }
}

class BigActionButton extends StatelessWidget {
  BigActionButton({
    @required this.exercise,
    @required this.delete,
  });

  final AnExercise exercise;
  final bool delete;

  //functions
  deleteFunc(){
    //stop the notification that may be running
    safeCancelNotification(exercise.id);

    //delete the exercise
    ExerciseData.deleteExercise(exercise.id);
  }
  
  hideFunc(){
    //stop the notification that may be running
    safeCancelNotification(exercise.id);

    //reset all temps
    exercise.tempWeight = null;
    exercise.tempReps = null;
    exercise.tempSetCount = null;
    exercise.tempStartTime = new ValueNotifier<DateTime>(AnExercise.nullDateTime);

    //mark as hidden
    exercise.lastTimeStamp = LastTimeStamp.hiddenDateTime();
  }

  //pop ups for archiving or deleting
  areyouSurePopUp(BuildContext context, {Color color, IconData icon}){
    String name = "\"" + exercise.name + "\"";
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ConfirmActionMessage(
          buttonColor: color, 
          image: (delete) ? Padding(
            padding: EdgeInsets.only(
              bottom: 36,
              top: 24,
            ),
            child: Container(
              height: 140,
              child: PlayGifOnce(
                assetName: "assets/popUpGifs/delete.gif",
                runTimeMS: 6120,
                frameCount: 98,
              ),
            ),
          )
          : Padding(
            padding: const EdgeInsets.only( 
              top: 24.0,
              bottom: 24,
            ),
            child: Container(
              height: 140,
              child: PlayGifOnce(
                assetName: "assets/popUpGifs/hide.gif",
                runTimeMS: 3660,
                //remove last frame cuz its gross
                frameCount: 32 - 1,
              ),
            ),
          ),
          iconSpace: (delete) ? 8 : 16, 
          icon: icon, 
          actionString: (delete) ? "Delete" : "Hide", 
          message: (delete) 
            ? DeleteMessage(theName: name) 
            : HideMessage(theName: name), 
          actionFunction: (){
            if(delete) deleteFunc();
            else hideFunc();
          }, 
        ); 
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    IconData icon = (delete) ? Icons.delete : FontAwesomeIcons.solidEyeSlash;
    Color color = (delete) ? Colors.red : Colors.blue;

    //build
    return Container(
      color: Colors.transparent,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            areyouSurePopUp(
              context,
              icon: icon,
              color: color,
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}