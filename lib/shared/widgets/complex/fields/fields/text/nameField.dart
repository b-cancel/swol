//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/fields/fields/text/textField/clearableTextField.dart';
import 'package:swol/shared/widgets/complex/fields/headers/fieldHeader.dart';
import 'package:swol/shared/widgets/simple/listItem.dart';
import 'package:swol/shared/methods/theme.dart';

//widgets
class NameField extends StatelessWidget {
  NameField({
    this.editOneAtATime: false,
    this.nameFocusNode,
    required this.nameToUpdate,
    required this.showError,
    required this.autofocus,
    this.namePresent, //only needed when the save button is activated with this
    this.noteFocusNode,
  });

  final bool editOneAtATime;
  final FocusNode? nameFocusNode;
  final ValueNotifier<String> nameToUpdate;
  final ValueNotifier<bool> showError;
  final bool autofocus;
  final ValueNotifier<bool>? namePresent;
  final FocusNode? noteFocusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Theme(
          data: MyTheme.light,
          child: HeaderWithInfo(
            header: "Name",
            title: "Exercise Name",
            subtitle: "Choose a unique name",
            body: _NamePopUpBody(),
          ),
        ),
        TextFieldWithClearButton(
          isName: true,
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
          noteFocusNode: noteFocusNode,
        ),
      ],
    );
  }
}

class _NamePopUpBody extends StatelessWidget {
  const _NamePopUpBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            textScaleFactor: MediaQuery.of(
              context,
            ).textScaleFactor,
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: "You can have ",
                ),
                TextSpan(
                  text: "multiple exercises",
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
              ],
            ),
          ),
          //---
          RichText(
            textScaleFactor: MediaQuery.of(
              context,
            ).textScaleFactor,
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
              ],
            ),
          ),
          //---
          RichText(
            textScaleFactor: MediaQuery.of(
              context,
            ).textScaleFactor,
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
                  text: " when you do the " +
                      "same exercise, multiple times, in the same workout" +
                      " but with a ",
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
            padding: EdgeInsets.only(
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
                  content: Text("Set Target"),
                ),
                ListItem(
                  circleColor: Colors.blue,
                  circleText: "3",
                  circleTextColor: Colors.white,
                  content: Text("Recovery Time"),
                ),
                ListItem(
                  circleColor: Colors.blue,
                  circleText: "4",
                  circleTextColor: Colors.white,
                  content: Text("Rep Target"),
                  bottomSpacing: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
