//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:bot_toast/bot_toast.dart';

//internal
import 'package:swol/shared/widgets/simple/ourToolTip.dart';

//functions
showWeightRepsAsPivotToolTip(context) {
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
                  "Recorded Reps",
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

showRepsRepsAsPivotToolTip(context) {
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
                  "We are using your ",
                ),
                Text(
                  "Recorded Reps",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Wrap(
              children: [
                Text(
                  "To calculate your ",
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
                  "This ",
                ),
                Text(
                  "helps when",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " the calculated",
                ),
              ],
            ),
            Wrap(
              children: [
                Text(
                  "Expected Reps are Higher Or Lower",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " than Recorded",
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    color: Colors.white,
    direction: PreferDirection.topCenter,
    seconds: 10,
  );
}
