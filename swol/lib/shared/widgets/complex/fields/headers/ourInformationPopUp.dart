//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/simple/ourLearnPopUp.dart';
import 'package:swol/shared/methods/theme.dart';

//widget
infoPopUpFunction(
  BuildContext context, 
  {
    String title: "",
    String subtitle: "",
    @required Widget body,
    isDense: false,
  }){
  showLearnPopUp(
    context,
    Icon(
      Icons.info,
      color: Colors.blue,
      //NOTE: not actual size but will take to max size
      size: 128,
    ),
    [
      title == null ? Container() : Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.black,
        ),
      ),
      subtitle == null ? Container() : Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
        ),
        child: Theme(
          data: MyTheme.dark,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: body,
          ),
        ),
      ),
    ],
    iconPadding: false,
    isDense: isDense,
  );
}