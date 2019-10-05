//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/excerciseAddition/informationPopUps.dart';
import 'package:swol/sharedWidgets/clearableTextField.dart';
import 'package:swol/sharedWidgets/informationDisplay.dart';
import 'package:swol/sharedWidgets/referenceLink.dart';

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
    //when url change we update
    widget.url.addListener((){
      setState(() {});
    });

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
        new TextFieldWithClearButton(
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
        new TextFieldWithClearButton(
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
        new ReferenceLinkBox(
          url: widget.url,
          editOneAtAtTime: widget.editOneAtAtTime,
        ),
      ],
    );
  }
}