//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:bot_toast/bot_toast.dart';

//internal
import 'package:swol/shared/widgets/simple/ourToolTip.dart';

//functions
showWeightRepsAsPivotToolTip(context){
  showWidgetToolTip(
    context,
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        BotToast.cleanAll();
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "The ",
            ),
            TextSpan(
              text: "Expected Weight\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: "Calculated from your ",
            ),
            TextSpan(
              text: "Recorded Reps",
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

showRepsRepsAsPivotToolTip(context){
  showWidgetToolTip(
    context,
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        BotToast.cleanAll();
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "We are using your ",
            ),
            TextSpan(
              text: "Recorded Reps\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: "To calculate your ",
            ),
            TextSpan(
              text: "Expected Weight\n",
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
            TextSpan(
              text: " the calculated\n"
            ),
            TextSpan(
              text: "Expected Reps are Higher Or Lower",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: " than Recorded",
            ),
          ],
        ),
      ),
    ),
    direction: PreferDirection.topCenter,
    seconds: 10,
  );
}