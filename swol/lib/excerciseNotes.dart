import 'package:flutter/material.dart';
import 'package:swol/addWorkout.dart';
import 'package:swol/utils/data.dart';

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

  //pop ups for archiving or deleting
  areyouSurePopUp(BuildContext context, bool delete){
    Function tripplePop = (){
      //get rid of this pop up
      Navigator.of(context).pop();

      //go back to our excercise page
      Navigator.of(context).pop();

      //go back to our list
      Navigator.of(context).pop();
    };

    //grab the name of the excercise
    String theName = getExcercises().value[widget.excerciseID].name;
    String actionString = (delete) ? "Delete" : "Hide";
    Color buttonColor = (delete) ? Colors.red : Colors.blue;
    Function actionFunction;
    if(delete){
      actionFunction = (){
        deleteExcercise(widget.excerciseID);
      };
    }
    else{
      actionFunction = (){
        updateExcercise(
          widget.excerciseID, 
          //archive it or get it out of the way
          //but placing it 200 years in the future
          //NO LESS
          //because we want to make sure for duration of life
          //that is archived and life is at most 100 years
          lastTimeStamp: DateTime.now().add(Duration(days: 365 * 2)),
        );
      };
    }
    Widget message;
    if(delete){
      message = RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: theName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )
            ),
            TextSpan(
              text: " will be ",
            ),
            TextSpan(
              text: "Permanently Deleted",
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            TextSpan(
              text: " from your list of excercises\n\n",
            ),
            TextSpan(
              text: "If you ",
            ),
            TextSpan(
              text: "don't want to lose your data,\n",
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            TextSpan(
              text: "but you do want to stop it from cycling back up the list, "
            ),
            TextSpan(
              text: "then you should "
            ),
            TextSpan(
              text: "Hide",
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            TextSpan(
              text: " it instead"
            ),
          ]
        ),
      );
    }
    else{
       message = RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: theName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )
            ),
            TextSpan(
              text: " will be ",
            ),
            TextSpan(
              text: "Hidden",
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            TextSpan(
              text: " at the bottom of your list of excercises\n\n",
            ),
            TextSpan(
              text: "If you ",
            ),
            TextSpan(
              text: "want to delete your excercise,\n",
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            TextSpan(
              text: "then you should "
            ),
            TextSpan(
              text: "Delete",
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            TextSpan(
              text: " it instead"
            ),
          ]
        ),
      );
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
              child: Text(
                actionString + " Excercise?",
                style: TextStyle(
                  color: Colors.white,
                ),
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
                  //TODO: perhaps make an edit here
                  actionFunction();
                  tripplePop();
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
    name.value = getExcercises().value[widget.excerciseID].name;
    note.value = getExcercises().value[widget.excerciseID].note;
    url.value = getExcercises().value[widget.excerciseID].url;

    //if values change properly update
    url.addListener((){
      updateExcercise(widget.excerciseID, url: url.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
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
                    Icons.archive,
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