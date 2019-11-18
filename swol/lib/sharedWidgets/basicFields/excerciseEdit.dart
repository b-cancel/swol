//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/excerciseAddition/informationPopUps.dart';
import 'package:swol/sharedWidgets/basicFields/clearableTextField.dart';
import 'package:swol/sharedWidgets/basicFields/referenceLink.dart';
import 'package:swol/sharedWidgets/informationDisplay.dart';

//editor of basic variables "name", "note", "url"
class BasicEditor extends StatefulWidget {
  const BasicEditor({
    Key key,
    @required this.namePresent,
    @required this.nameError,
    @required this.name,
    @required this.note,
    @required this.url,
    this.editOneAtAtTime: false,
  }) : super(key: key);

  final ValueNotifier<bool> namePresent;
  final ValueNotifier<bool> nameError;
  final ValueNotifier<String> name; 
  final ValueNotifier<String> note; 
  final ValueNotifier<String> url;
  final bool editOneAtAtTime;

  @override
  _BasicEditorState createState() => _BasicEditorState();
}

class _BasicEditorState extends State<BasicEditor> {
  FocusNode noteFocusNode = FocusNode();

  @override
  void initState() {
    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        HeaderWithInfo(
          title: "Name",
          popUp: ExcerciseNamePopUp(),
        ),
        TextFieldWithClearButton(
          editOneAtAtTime: widget.editOneAtAtTime,
          valueToUpdate: widget.name,
          hint: "Required*", 
          error: (widget.nameError.value) ? "Name Is Required" : null, 
          //auto focus field
          autofocus: true,
          //we need to keep track above to determine whether we can active the button
          present: widget.namePresent, 
          //so next focuses on the note
          otherFocusNode: noteFocusNode,
        ),
        HeaderWithInfo(
          title: "Notes",
          popUp: ExcerciseNotePopUp(),
        ),
        TextFieldWithClearButton(
          editOneAtAtTime: widget.editOneAtAtTime,
          valueToUpdate: widget.note,
          hint: "Details", 
          error: null, 
          //so we can link up both fields
          focusNode: noteFocusNode,
        ),
        Container(
          child: HeaderWithInfo(
            title: "Reference Link",
            popUp: new ReferenceLinkPopUp(),
          ),
        ),
        ReferenceLinkBox(
          url: widget.url,
          editOneAtAtTime: widget.editOneAtAtTime,
        ),
      ],
    );
  }
}

class BackFromExcercise extends StatelessWidget {
  const BackFromExcercise({
    Key key,
    this.navSpread,
  }) : super(key: key);

  final ValueNotifier<bool> navSpread;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const BackButtonIcon(),
      color: Theme.of(context).iconTheme.color,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () {
        //close keyboard if perhaps typing next set
        FocusScope.of(context).unfocus();

        //navigator
        if(navSpread != null){
          navSpread.value = false;
        }
        
        //to excercise do, or excercise list page
        Navigator.of(context).pop();
      },
    );
  }
}