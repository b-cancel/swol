import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:swol/shared/widgets/simple/ourToolTip.dart';

showRepsToolTip(BuildContext context, {
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
        text: TextSpan(children: [
          TextSpan(text: "How many times you lifted the weight\n"),
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

showWeightToolTip(BuildContext context, {
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
        text: TextSpan(children: [
          TextSpan(text: "It doesn't matter\nif you use"),
          TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            text: " LBS",
          ),
          TextSpan(
            text: " or ",
          ),
          TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            text: "KG\n",
          ),
          TextSpan(text: "As long as you keep things "),
          TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            text: "consistent\n",
          ),
          TextSpan(text: "the math will work as expected"),
        ]),
      ),
    ),
    direction: direction,
    seconds: 8,
  );
}
