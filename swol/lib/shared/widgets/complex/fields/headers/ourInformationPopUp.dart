//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';

//internal
import 'package:swol/shared/methods/theme.dart';

//widget
infoPopUpFunction(
  BuildContext context, {
  String title,
  String subtitle,
  @required Widget body,
  isDense: false,
}) {
  AwesomeDialog(
    context: context,
    isDense: isDense,
    dismissOnTouchOutside: true,
    animType: AnimType.SCALE,
    dialogType: DialogType.INFO,
    body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: title != null,
          maintainSize: false,
          child: Text(
            title ?? "",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
        Visibility(
          visible: subtitle != null,
          maintainSize: false,
          child: Text(
            subtitle ?? "",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: (title != null || subtitle != null) ? 16.0 : 0,
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
    ),
  ).show();
}