//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';

//internal
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/widgets/simple/ourHeaderIconPopUp.dart';

//widget
infoPopUpFunction(
  BuildContext context, {
  String title,
  String subtitle,
  @required Widget body,
  isDense: false,
}) {
  showBasicHeaderIconPopUp(
    context,
    [
      Visibility(
        visible: title != null,
        maintainSize: false,
        child: Text(
          title ?? "",
          style: TextStyle(
            fontSize: 24,
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
          ),
        ),
      ),
    ],
    [
      Theme(
        data: MyTheme.dark,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: body,
        ),
      ),
    ],
    DialogType.INFO,
    isDense: isDense,
    animationType: AnimType.SCALE,
  );
}
