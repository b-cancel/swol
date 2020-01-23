//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/main.dart';
import 'package:swol/shared/widgets/complex/fields/name.dart';
import 'package:swol/shared/widgets/complex/fields/notes.dart';
import 'package:swol/shared/widgets/complex/fields/link.dart';

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
            valueToUpdate: name,
            showError: nameError,
            autofocus: true,
            namePresent: namePresent,
            otherFocusNode: noteFocusNode,
          ),
          NotesField(
            editOneAtATime: editOneAtAtTime,
            valueToUpdate: note,
            focusNode: noteFocusNode,
          ),
          ReferenceLink(
            url: url,
            editOneAtATime: editOneAtAtTime,
          ),
        ],
      ),
    );
  }
}

class BackFromExcercise extends StatelessWidget {
  const BackFromExcercise({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.chevron_left),
      color: Theme.of(context).iconTheme.color,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () {
        //close keyboard if perhaps typing next set
        FocusScope.of(context).unfocus();

        //navigator
        App.navSpread.value = false;
        
        //to excercise do, or excercise list page
        Navigator.of(context).pop();
      },
    );
  }
}