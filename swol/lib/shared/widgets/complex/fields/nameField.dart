//flutter
import 'package:flutter/material.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/fields/headers/fieldHeader.dart';
import 'package:swol/shared/widgets/simple/listItem.dart';
import 'package:swol/shared/functions/theme.dart';

//internal: other
import 'package:swol/basicFields/clearableTextField.dart';

//widgets
class NameField extends StatelessWidget {
  NameField({
    this.editOneAtATime: false,
    this.nameFocusNode,
    @required this.nameToUpdate,
    @required this.showError,
    @required this.autofocus,
    @required this.namePresent,
    @required this.noteFocusNode,
  });

  final bool editOneAtATime;
  final FocusNode nameFocusNode;
  final ValueNotifier<String> nameToUpdate;
  final ValueNotifier<bool> showError;
  final bool autofocus;
  final ValueNotifier<bool> namePresent;
  final FocusNode noteFocusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Theme(
          data: MyTheme.light,
          child: HeaderWithInfo(
            header: "Name",
            title: "Excercise Name",
            subtitle: "Choose a unique name",
            body: _NamePopUpBody(),
          ),
        ),
        TextFieldWithClearButton(
          editOneAtAtTime: editOneAtATime,
          valueToUpdate: nameToUpdate,
          focusNode: nameFocusNode,
          hint: "Required*", 
          error: (showError.value) ? "Name Is Required" : null, 
          //auto focus field (this is handled by the save button)
          autofocus: autofocus,
          //we need to keep track above to determine whether we can active the button
          present: namePresent, 
          //so next focuses on the note
          otherFocusNode: noteFocusNode,
        ),
      ],
    );
  }
}

class _NamePopUpBody extends StatelessWidget {
  const _NamePopUpBody({
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
                  text: "You can have ",
                ),
                TextSpan(
                  text: "multiple excercises",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " with the ",
                ),
                TextSpan(
                  text: "same name\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            ),
          ),
          //---
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: "But, it's best",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " if you keep the name ",
                ),
                TextSpan(
                  text: "unique\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            ),
          ),
          //---
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: "Especially",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " when you do the "
                  + "same excercise, multiple times, in the same workout"
                  + " but with a ",
                ),
                TextSpan(
                  text: "different",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
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
                  content: Text("Previous Set"),
                ),
                ListItem(
                  circleColor: Colors.blue,
                  circleText: "2",
                  circleTextColor: Colors.white,
                  content: Text("Ability Formula"),
                ),
                ListItem(
                  circleColor: Colors.blue,
                  circleText: "3",
                  circleTextColor: Colors.white,
                  content: Text("Rep Target"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}