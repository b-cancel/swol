//flutter
import 'package:flutter/material.dart';

//internal: basic
import 'package:swol/basicFields/clearableTextField.dart';
import 'package:swol/basicFields/referenceLink.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/settingHeaders/headerWithInfoButton.dart';

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
          NameHeader(),
          TextFieldWithClearButton(
            editOneAtAtTime: editOneAtAtTime,
            valueToUpdate: name,
            hint: "Required*", 
            error: (nameError.value) ? "Name Is Required" : null, 
            //auto focus field
            autofocus: true,
            //we need to keep track above to determine whether we can active the button
            present: namePresent, 
            //so next focuses on the note
            otherFocusNode: noteFocusNode,
          ),
          NotesHeader(),
          TextFieldWithClearButton(
            editOneAtAtTime: editOneAtAtTime,
            valueToUpdate: note,
            hint: "Details", 
            error: null, 
            //so we can link up both fields
            focusNode: noteFocusNode,
          ),
          ReferenceLinkHeader(),
          ReferenceLinkBox(
            url: url,
            editOneAtAtTime: editOneAtAtTime,
          ),
        ],
      ),
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