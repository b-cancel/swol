import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/widgets/simple/ourHeaderIconPopUp.dart';

//false -> naw
//true -> try again
Future requestThatYouGoToAppSettings(BuildContext context) async {
  double textScaleFactor = MediaQuery.of(context).textScaleFactor;
  return await showCustomHeaderIconPopUp(
    context,
    [
      Text(
        "Manually",
        style: TextStyle(
          fontSize: 24,
        ),
      ),
      Text(
        "Enable Notifications",
        style: TextStyle(
          fontSize: 24,
        ),
      ),
      Text(
        "In App Settings",
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    ],
    [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              textScaleFactor: textScaleFactor,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "Since ",
                  ),
                  TextSpan(
                    text: "you manually disabled notifications",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ", you will need to manually re-enable them.",
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 8.0,
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                onPressed: () {
                  openAppSettings();
                },
                child: Text("Open App Settings"),
              ),
            ),
          ],
        ),
      ),
    ],
    Icon(
      Icons.settings,
      color: Colors.white,
    ),
    headerBackground: MyTheme.dark.cardColor,
    dismissOnTouchOutside: false,
    /*
    clearBtn: TextButton(
      child: Text("Nevermind"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    ),
    */
    colorBtn: ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop(true);
      },
      child: Text("Try Again Later"),
    ),
  );
}
