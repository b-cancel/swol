//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:bot_toast/bot_toast.dart';

//internal
import 'package:swol/shared/widgets/simple/ourToolTip.dart';

//functions
showWeightRepTargetAsPivotToolTip(context){
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
              text: "Rep Target",
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

showRepsRepTargetAsPivotToolTip(context){
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
              text: "Rep Target\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: "Used to calculate your ",
            ),
            TextSpan(
              text: "Expected Weight",
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