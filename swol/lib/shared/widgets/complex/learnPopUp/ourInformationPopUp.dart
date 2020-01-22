//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/learnPopUp/ourLearnPopUp.dart';

//widget
infoPopUpFunction(
  BuildContext context, 
  {
    @required title,
    subtitle: "",
    @required body,
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
      Text(
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
          data: ThemeData.dark(),
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