//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:bot_toast/bot_toast.dart';

//internal
import 'package:swol/shared/widgets/simple/ourToolTip.dart';

//functions
showWeightRepTargetAsPivotToolTip(context) {
  showWidgetToolTip(
    context,
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        BotToast.cleanAll();
      },
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.black,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Text(
                  "The ",
                ),
                Text(
                  "Expected Weight",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Wrap(
              children: [
                Text(
                  "Calculated from your ",
                ),
                Text(
                  "Rep Target",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    color: Colors.white,
    direction: PreferDirection.topCenter,
    seconds: 5,
  );
}

showRepsRepTargetAsPivotToolTip(context) {
  showWidgetToolTip(
    context,
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        BotToast.cleanAll();
      },
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.black,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Text(
                  "The ",
                ),
                Text(
                  "Rep Target",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Wrap(
              children: [
                Text(
                  "Used to calculate your ",
                ),
                Text(
                  "Expected Weight",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    color: Colors.white,
    direction: PreferDirection.topCenter,
    seconds: 5,
  );
}
