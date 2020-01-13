//flutter
import 'package:flutter/material.dart';

//internal other
import 'package:swol/excerciseAddition/popUps/popUpFunctions.dart';

//internal shared
import 'package:swol/sharedWidgets/basicFields/clearableTextField.dart';
import 'package:swol/sharedWidgets/basicFields/referenceLink.dart';
import 'package:swol/sharedWidgets/informationDisplay.dart';

class NameCard extends StatefulWidget {
  const NameCard({
    Key key,
    @required this.name,
    @required this.nameError,
    @required this.namePresent,
    @required this.nameFocusNode,
    @required this.noteFocusNode,
  }) : super(key: key);

  final ValueNotifier<String> name;
  final ValueNotifier<bool> nameError;
  final ValueNotifier<bool> namePresent;
  final FocusNode nameFocusNode;
  final FocusNode noteFocusNode;

  @override
  _NameCardState createState() => _NameCardState();
}

class _NameCardState extends State<NameCard> {
  updateState(){
    if(mounted) setState(() {});
  }

  @override
  void initState() {
    widget.nameError.addListener(updateState);

    super.initState();
  }

  @override
  void dispose() { 
    widget.nameError.removeListener(updateState);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          HeaderWithInfo(
            title: "Name",
            popUpFunction: () => excerciseNamePopUp(context),
          ),
          TextFieldWithClearButton(
            editOneAtAtTime: false,
            valueToUpdate: widget.name,
            focusNode: widget.nameFocusNode,
            hint: "Required*", 
            error: (widget.nameError.value) ? "Name Is Required" : null, 
            //auto focus field (this is handled by the save button)
            autofocus: false,
            //we need to keep track above to determine whether we can active the button
            present: widget.namePresent, 
            //so next focuses on the note
            otherFocusNode: widget.noteFocusNode,
          ),
        ],
      ),
    );
  }
}

class NotesCard extends StatelessWidget {
  const NotesCard({
    Key key,
    @required this.note,
    @required this.noteFocusNode,
  }) : super(key: key);

  final ValueNotifier<String> note;
  final FocusNode noteFocusNode;

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          HeaderWithInfo(
            title: "Notes",
            popUpFunction: () => excerciseNotePopUp(context),
          ),
          TextFieldWithClearButton(
            editOneAtAtTime: false,
            valueToUpdate: note,
            hint: "Details", 
            error: null, 
            //so we can link up both fields
            focusNode: noteFocusNode,
          ),
        ],
      ),
    );
  }
}

class LinkCard extends StatefulWidget {
  const LinkCard({
    Key key,
    @required this.url,
  }) : super(key: key);

  final ValueNotifier<String> url;

  @override
  _LinkCardState createState() => _LinkCardState();
}

class _LinkCardState extends State<LinkCard> {
  updateState(){
    if(mounted) setState(() {});
  }

  @override
  void initState() {
    widget.url.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() {
    widget.url.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: HeaderWithInfo(
              title: "Reference Link",
              popUpFunction: () => referenceLinkPopUp(context),
            ),
          ),
          ReferenceLinkBox(
            url: widget.url,
            editOneAtAtTime: false,
          ),
        ],
      ),
    );
  }
}

class BasicCard extends StatelessWidget {
  const BasicCard({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Card(
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16,
            bottom: 16,
            top: 8,
          ),
          child: child,
        ),
      ),
    );
  }
}