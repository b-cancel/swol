//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:bot_toast/bot_toast.dart';

//internal
import 'package:swol/shared/widgets/simple/ourToolTip.dart';

//function
showWeightToolTip(
  BuildContext context, {
  PreferDirection direction: PreferDirection.topCenter,
}) {
  showWidgetToolTip(
    context,
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        BotToast.cleanAll();
      },
      child: RichText(
        textScaleFactor: MediaQuery.of(
          context,
        ).textScaleFactor,
        text: TextSpan(
          children: [
            TextSpan(text: "the weight you lifted\n"),
            TextSpan(
              text: "(",
            ),
            TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              text: "LBS",
            ),
            TextSpan(
              text: " or ",
            ),
            TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              text: "KG",
            ),
            TextSpan(
              text: ")",
            ),
          ],
        ),
      ),
    ),
    direction: direction,
    seconds: 8,
  );
}

showRepsToolTip(
  BuildContext context, {
  PreferDirection direction: PreferDirection.bottomCenter,
}) {
  showWidgetToolTip(
    context,
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        BotToast.cleanAll();
      },
      child: RichText(
        textScaleFactor: MediaQuery.of(
          context,
        ).textScaleFactor,
        text: TextSpan(children: [
          TextSpan(text: "how many times you lifted the weight\n"),
          TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            text: "Successfully",
          ),
          TextSpan(
            text: " and with ",
          ),
          TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            text: "Good Form",
          ),
        ]),
      ),
    ),
    direction: direction,
  );
}
