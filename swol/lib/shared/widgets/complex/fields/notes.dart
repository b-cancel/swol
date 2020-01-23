//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/fields/headers/headerWithInfoButton.dart';
import 'package:swol/basicFields/clearableTextField.dart';
import 'package:swol/shared/functions/theme.dart';
import 'package:swol/learn/shared.dart';

//widgets
class NotesField extends StatelessWidget {
  NotesField({
    this.editOneAtATime: false,
    @required this.noteToUpdate,
    this.noteFocusNode,
  });

  final bool editOneAtATime;
  final ValueNotifier<String> noteToUpdate;
  final FocusNode noteFocusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Theme(
          data: MyTheme.light,
          child: HeaderWithInfo(
            header: "Notes",
            title: "Excercise Note",
            subtitle: "Details",
            body: _NotePopUpBody(),
          ),
        ),
        TextFieldWithClearButton(
          editOneAtAtTime: editOneAtATime,
          valueToUpdate: noteToUpdate,
          hint: "Details", 
          error: null, 
          //so we can link up both fields
          focusNode: noteFocusNode,
        ),
      ],
    );
  }
}

class _NotePopUpBody extends StatelessWidget {
  const _NotePopUpBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 32,
        right: 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: "A space for any ",
                ),
                TextSpan(
                  text: "extra details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " that you may want to keep in mind before starting the excercise",
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
            ),
            child: Column(
              children: <Widget>[
                ListItem(
                  circleColor: Colors.blue,
                  circleText: "1",
                  circleTextColor: Colors.white,
                  content: Text("Grip Type"),
                ),
                ListItem(
                  circleColor: Colors.blue,
                  circleText: "2",
                  circleTextColor: Colors.white,
                  content: Text("Hold Duration"),
                ),
                ListItem(
                  circleColor: Colors.blue,
                  circleText: "3",
                  circleTextColor: Colors.white,
                  content: Text("Muscles To Focus On"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}