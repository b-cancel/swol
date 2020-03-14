import 'package:flutter/material.dart';
import 'package:swol/shared/methods/theme.dart';

requestVibrationPermission(BuildContext context, Function onComplete) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return Theme(
        data: MyTheme.light,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          contentPadding: EdgeInsets.all(0),
          content: Column(
            children: [
              
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
