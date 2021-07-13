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
                "Recorded Weight",
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
                "Expected Reps",
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
                "Expected Reps are Not Available",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
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
                "Expected Reps",
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
                "Recorded Weight",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    direction: PreferDirection.topCenter,
    seconds: 5,
  );
}
