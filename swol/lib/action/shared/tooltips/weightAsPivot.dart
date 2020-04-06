//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:bot_toast/bot_toast.dart';

//internal
import 'package:swol/shared/widgets/simple/ourToolTip.dart';

//functions
showWeightWeightAsPivotToolTip(context) {
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
            TextSpan(
              text: "We are using your ",
            ),
            TextSpan(
              text: "Recorded Weight\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: "To calculate your ",
            ),
            TextSpan(
              text: "Expected Reps\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: "This ",
            ),
            TextSpan(
              text: "helps when",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: " the calculated\n"),
            TextSpan(
              text: "Expected Weight is Not Available",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
    direction: PreferDirection.topCenter,
    seconds: 10,
  );
}

showRepsWeightAsPivotToolTip(context) {
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
            TextSpan(
              text: "The ",
            ),
            TextSpan( 
              text: "Expected Reps\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: "Calculated from your ",
            ),
            TextSpan(
              text: "Recorded Weight",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
    direction: PreferDirection.topCenter,
    seconds: 5,
  );
}
