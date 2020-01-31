//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//internl: excercise
import 'package:swol/shared/widgets/complex/fields/fields/linkField/link.dart';
import 'package:swol/shared/widgets/complex/fields/fields/text/nameField.dart';
import 'package:swol/shared/widgets/complex/fields/fields/text/notesField.dart';
import 'package:swol/shared/functions/defaultDateTimes.dart';
import 'package:swol/shared/widgets/simple/backButton.dart';
import 'package:swol/shared/methods/excerciseData.dart';

//internal: other
import 'package:swol/pages/notes/excerciseMessages.dart';
import 'package:swol/sharedWidgets/playOnceGif.dart';

//widget
class ExcerciseNotes extends StatefulWidget {
  ExcerciseNotes({
    @required this.excerciseID,
  });

  final int excerciseID;

  @override
  _ExcerciseNotesState createState() => _ExcerciseNotesState();
}

class _ExcerciseNotesState extends State<ExcerciseNotes> {
  //basics
  ValueNotifier<bool> nameError = new ValueNotifier(false);
  ValueNotifier<String> name = new ValueNotifier("");
  ValueNotifier<String> note = new ValueNotifier("");
  ValueNotifier<String> url = new ValueNotifier("");

  //listener function
  updateName(){
    //NOTE: name will only be set if its NOT EMTPY
    ExcerciseData.updateExcercise(widget.excerciseID, name: name.value);
  }

  updateNote(){
    ExcerciseData.updateExcercise(widget.excerciseID, note: note.value);
  }

  updateUrl(){
    ExcerciseData.updateExcercise(widget.excerciseID, url: url.value);
  }

  @override
  void initState() { 
    //super init
    super.initState();

    //set initial values of ValueNotifiers
    AnExcercise thisExcercise = ExcerciseData.getExcercises()[widget.excerciseID];
    name.value = thisExcercise.name;
    note.value = thisExcercise.note;
    url.value = thisExcercise.url;

    name.addListener(updateName);
    note.addListener(updateNote);
    url.addListener(updateUrl);
  }

  @override
  void dispose() { 
    name.removeListener(updateName);
    note.removeListener(updateNote);
    url.removeListener(updateUrl);
    
    //super dispose
    super.dispose();
  }

  final FocusNode noteFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: BackFromExcercise(),
        title: Text("Notes"),
        actions: [
          BigActionButton(
            excerciseID: widget.excerciseID,
            delete: false,
          ),
          BigActionButton(
            excerciseID: widget.excerciseID,
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
    );
  }
}

class BigActionButton extends StatelessWidget {
  BigActionButton({
    @required this.excerciseID,
    @required this.delete,
  });

  final int excerciseID;
  final bool delete;

  //pop ups for archiving or deleting
  areyouSurePopUp(BuildContext context, {Color color, IconData icon}){
    //create action function
    Function actionFunction;
    if(delete){
      actionFunction = (){
        ExcerciseData.deleteExcercise(excerciseID);
      };
    }
    else{
      actionFunction = (){
        ExcerciseData.updateExcercise(
          excerciseID, 
          //set to hidden
          lastTimeStamp: LastTimeStamp.hiddenDateTime(),
          //wipe all temp vars
          tempRepsCanBeNull: true,
          tempSetCountCanBeNull: true,
          tempStartTimeCanBeNull: true,
          tempWeightCanBeNull: true,
        );
      };
    }

    //grab the name of the excercise
    String theName = ExcerciseData.getExcercises()[excerciseID].name;
    theName = "\"" + theName + "\"";

    //show the dialog
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
            ? DeleteMessage(theName: theName) 
            : HideMessage(theName: theName), 
          actionFunction: actionFunction, 
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