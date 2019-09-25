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
  ValueNotifier<bool> editingName = new ValueNotifier(false);

  ValueNotifier<bool> editingNote = new ValueNotifier(false);

  ValueNotifier<bool> editingUrl = new ValueNotifier(false);

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
              text: " from your list of Excercises\n\n",
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
              text: "then you should instead "
            ),
            TextSpan(
              text: "Hide It",
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
          ]
        ),
      );
    }
    else message = Text("archive... really?");

    //show the dialog
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            title: Text(actionString + " Excercise?"),
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          MaybeEdit(
            content: getExcercises().value[widget.excerciseID].name,
            alt: "Add Name",
          ),
          MaybeEdit(
            content: getExcercises().value[widget.excerciseID].note,
            alt: "Add Note",
          ),
          MaybeEdit(
            content: getExcercises().value[widget.excerciseID].url,
            alt: "Add Url",
          ),
        ],
      ),
    );
  }
}

class MaybeEdit extends StatelessWidget {
  MaybeEdit({
    @required this.content,
    @required this.alt,
  });

  final String content;
  final String alt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: ClipRRect(
        borderRadius: new BorderRadius.all(
          Radius.circular(16.0),
        ), //instrinc height below
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FlatButton(
                padding: EdgeInsets.all(0),
                color: Theme.of(context).accentColor,
                onPressed: (){

                },
                child: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColorDark,
                )
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).backgroundColor,
                  padding: EdgeInsets.all(8),
                  child: Text(
                    (content != "") ? content : alt,
                    style: TextStyle(
                      color: (content == "") 
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}