//flutter
import 'package:flutter/material.dart';

//internal: basic
import 'package:swol/basicFields/clearableTextField.dart';
import 'package:swol/basicFields/referenceLink.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/settingHeaders/headerWithInfoButton.dart';

//widget
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
      child: NameField(
        editOneAtATime: false,
        valueToUpdate: widget.name,
        focusNode: widget.nameFocusNode,
        showError: widget.nameError,
        autofocus: false,
        namePresent: widget.namePresent,
        otherFocusNode: widget.noteFocusNode,
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
      child: NotesField(
        editOneAtATime: false,
        valueToUpdate: note,
        focusNode: noteFocusNode,
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
          ReferenceLinkHeader(),
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
    return Card(
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
    );
  }
}