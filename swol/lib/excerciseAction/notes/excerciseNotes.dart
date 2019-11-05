import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/excercise/defaultDateTimes.dart';
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excerciseAction/notes/excerciseMessages.dart';
import 'package:swol/sharedWidgets/excerciseEdit.dart';

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

  //pop ups for archiving or deleting
  areyouSurePopUp(BuildContext context, bool delete){
    //grab the name of the excercise
    String theName = ExcerciseData.getExcercises().value[widget.excerciseID].name;
    theName = "\"" + theName + "\"";
    String actionString = (delete) ? "Delete" : "Hide";
    Color buttonColor = (delete) ? Colors.red : Colors.blue;
    IconData icon = (delete) ? Icons.delete : FontAwesomeIcons.solidEyeSlash;
    double iconSpace = (delete) ? 8 : 16;

    //create action function
    Function actionFunction;
    if(delete){
      actionFunction = (){
        ExcerciseData.deleteExcercise(widget.excerciseID);
      };
    }
    else{
      actionFunction = (){
        ExcerciseData.updateExcercise(
          widget.excerciseID, 
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

    //create message
    Widget message;
    if(delete){
      message = new DeleteMessage(theName: theName);
    }
    else{
       message = new HideMessage(theName: theName);
    }

    //show the dialog
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            titlePadding: EdgeInsets.all(0),
            title: Container(
              padding: EdgeInsets.all(16),
              color: buttonColor,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      right: iconSpace,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    actionString + " Excercise?",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            contentPadding: EdgeInsets.all(0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: message,
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text(
                  "No, Don't " + actionString,
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              ),
              RaisedButton(
                color: buttonColor,
                onPressed: (){
                  //get rid of keyboard that MAY be shown
                  FocusScope.of(context).unfocus();

                  print("before deleting");
                  actionFunction();

                  //get rid of this pop up
                  Navigator.of(context).pop();

                  //go back to our excercise page
                  Navigator.of(context).pop();

                  //go back to our list
                  Navigator.of(context).pop();

                  //show the changing nav bar
                  widget.navSpread.value = false;
                },
                child: Text(
                  "Yes, " + actionString,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ); 
      },
    );
  }

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
        leading: new BackFromExcercise(),
        title: Text("Notes"),
        actions: [
          Container(
            color: Colors.transparent,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (){
                  areyouSurePopUp(context, false);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Icon(
                    FontAwesomeIcons.solidEyeSlash,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.transparent,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (){
                  areyouSurePopUp(context, true);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
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