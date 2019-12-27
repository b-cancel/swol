import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/excercise/defaultDateTimes.dart';
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excerciseAction/notes/excerciseMessages.dart';
import 'package:swol/sharedWidgets/basicFields/excerciseEdit.dart';

class BigAction extends StatelessWidget {
  BigAction({
    @required this.excerciseID,
    @required this.navSpread,
    @required this.delete,
  });

  final int excerciseID;
  final ValueNotifier<bool> navSpread;
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
              child: Image.asset(
                "assets/popUpGifs/delete.gif",
                color: Colors.white,
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
              child: Image.asset(
                "assets/popUpGifs/hide.gif",
                color: Colors.white,
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
          navSpread: navSpread,
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
    @required this.navSpread,
  });

  final int excerciseID;
  final ValueNotifier<bool> navSpread;

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

  @override
  void initState() { 
    //super init
    super.initState();

    //set initial values of ValueNotifiers
    name.value = ExcerciseData.getExcercises().value[widget.excerciseID].name;
    note.value = ExcerciseData.getExcercises().value[widget.excerciseID].note;
    url.value = ExcerciseData.getExcercises().value[widget.excerciseID].url;

    name.addListener((){
      //NOTE: name will only be set if its NOT EMTPY
      ExcerciseData.updateExcercise(widget.excerciseID, name: name.value);
    });

    note.addListener((){
      ExcerciseData.updateExcercise(widget.excerciseID, note: note.value);
    });

    //if values change properly update
    url.addListener((){
      ExcerciseData.updateExcercise(widget.excerciseID, url: url.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        leading: BackFromExcercise(),
        title: Text("Notes"),
        actions: [
          BigAction(
            excerciseID: widget.excerciseID,
            navSpread: widget.navSpread,
            delete: false,
          ),
          BigAction(
            excerciseID: widget.excerciseID,
            navSpread: widget.navSpread,
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
            child: Theme(
              data: ThemeData.light(),
              child: BasicEditor(
                namePresent: namePresent,
                nameError: nameError,
                name: name,
                note: note,
                url: url,
                editOneAtAtTime: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}