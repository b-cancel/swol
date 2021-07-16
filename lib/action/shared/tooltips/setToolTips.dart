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
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.black,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                "the weight you lifted",
              ),
            ),
            Wrap(
              children: <Widget>[
                Text(
                  "(",
                ),
                Text(
                  "LBS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " or ",
                ),
                Text(
                  "KG",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ")",
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    color: Colors.white,
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
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.black,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                "how many times you lifted the weight",
              ),
            ),
            Wrap(
              children: <Widget>[
                Text(
                  "Successfully",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " and with ",
                ),
                Text(
                  "Good Form",
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
    direction: direction,
  );
}
