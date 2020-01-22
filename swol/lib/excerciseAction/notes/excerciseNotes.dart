//flutter
import 'package:flutter/material.dart';
import 'package:swol/basicFields/excerciseEdit.dart';

//internl: excercise
import 'package:swol/excercise/defaultDateTimes.dart';
import 'package:swol/excercise/excerciseData.dart';

//internal: other
import 'package:swol/excerciseAction/notes/excerciseMessages.dart';
import 'package:swol/sharedWidgets/playOnceGif.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BigAction extends StatelessWidget {
  BigAction({
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
    String theName = ExcerciseData.getExcercises().value[excerciseID].name;
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
  ValueNotifier<bool> namePresent = new ValueNotifier(false);
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
    name.value = ExcerciseData.getExcercises().value[widget.excerciseID].name;
    note.value = ExcerciseData.getExcercises().value[widget.excerciseID].note;
    url.value = ExcerciseData.getExcercises().value[widget.excerciseID].url;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: BackFromExcercise(),
        title: Text("Notes"),
        actions: [
          BigAction(
            excerciseID: widget.excerciseID,
            delete: false,
          ),
          BigAction(
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
            child: BasicEditor(
              namePresent: namePresent,
              nameError: nameError,
              name: name,
              note: note,
              url: url,
              editOneAtAtTime: true,
            ),
          ),
        ],
      ),
    );
  }
}