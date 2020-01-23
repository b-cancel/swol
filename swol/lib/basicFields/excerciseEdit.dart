//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/fields/link/linkEditor.dart';
import 'package:swol/shared/widgets/complex/fields/name.dart';
import 'package:swol/shared/widgets/complex/fields/notes.dart';

//editor of basic variables "name", "note", "url"
class BasicEditor extends StatelessWidget {
  BasicEditor({
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

  //local
  final FocusNode noteFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          NameField(
            editOneAtATime: editOneAtAtTime,
            nameToUpdate: name,
            showError: nameError,
            autofocus: true,
            namePresent: namePresent,
            noteFocusNode: noteFocusNode,
          ),
          NotesField(
            editOneAtATime: editOneAtAtTime,
            noteToUpdate: note,
            noteFocusNode: noteFocusNode,
          ),
          LinkEditor(
            url: url,
            editOneAtATime: editOneAtAtTime,
          ),
        ],
      ),
    );
  }
}