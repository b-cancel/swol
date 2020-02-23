//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/action/page.dart';

//internl: excercise
import 'package:swol/shared/widgets/complex/fields/fields/linkField/link.dart';
import 'package:swol/shared/widgets/complex/fields/fields/text/nameField.dart';
import 'package:swol/shared/widgets/complex/fields/fields/text/notesField.dart';
import 'package:swol/shared/widgets/simple/playOnceGif.dart';
import 'package:swol/shared/functions/defaultDateTimes.dart';
import 'package:swol/shared/methods/excerciseData.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//internal: other
import 'package:swol/pages/notes/excerciseMessages.dart';

//widget
class ExcerciseNotes extends StatefulWidget {
  ExcerciseNotes({
    @required this.excercise,
  });

  final AnExcercise excercise;

  @override
  _ExcerciseNotesState createState() => _ExcerciseNotesState();
}

class _ExcerciseNotesState extends State<ExcerciseNotes> {
  //basics
  ValueNotifier<bool> nameError = new ValueNotifier(false);
  ValueNotifier<String> name = new ValueNotifier("");
  ValueNotifier<String> note = new ValueNotifier("");
  ValueNotifier<String> url = new ValueNotifier("");

  //listener functions
  updateName() => widget.excercise.name = name.value;
  updateNote() => widget.excercise.note = note.value;
  updateUrl() => widget.excercise.url = url.value;

  //init
  @override
  void initState() { 
    //super init
    super.initState();

    //set initial values of ValueNotifiers
    name.value = widget.excercise.name;
    note.value = widget.excercise.note;
    url.value = widget.excercise.url;

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
    
    //super dispose
    super.dispose();
  }

  final FocusNode noteFocusNode = FocusNode();

  goBackToExcercisePage(){
    //close any keyboard that may be open
    FocusScope.of(context).unfocus();
    //indicate that we should refocus inf needed
    ExcercisePage.causeRefocusIfInvalid.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        goBackToExcercisePage();
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorDark,
          leading: FittedBox(
            fit: BoxFit.contain,
            child: IconButton(
              icon: Icon(Icons.chevron_left),
              color: Theme.of(context).iconTheme.color,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () {
                goBackToExcercisePage();
                Navigator.of(context).pop();
              },
            ),
          ),
          title: Text("Notes"),
          actions: [
            BigActionButton(
              excercise: widget.excercise,
              delete: false,
            ),
            BigActionButton(
              excercise: widget.excercise,
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
    @required this.excercise,
    @required this.delete,
  });

  final AnExcercise excercise;
  final bool delete;

  //functions
  deleteFunc() => ExcerciseData.deleteExcercise(excercise.id);
  hideFunc() => excercise.lastTimeStamp = LastTimeStamp.hiddenDateTime();

  //pop ups for archiving or deleting
  areyouSurePopUp(BuildContext context, {Color color, IconData icon}){
    String name = "\"" + excercise.name + "\"";
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