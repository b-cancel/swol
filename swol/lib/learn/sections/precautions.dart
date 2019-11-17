//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/learn/shared.dart';

class PrecautionsBody extends StatelessWidget {
  const PrecautionsBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionDescription(
          child: Text(
            "Every exercise has its own unique risks\n\n"
            + "So make sure you do the research, in order to fully understand how to eliminate or minimize them\n\n"
            + "Below are some of the most common precautions you can take",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 16,
            ),
            child: Column(
              children: <Widget>[
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  content: Text(
                    "use a spotter",
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  content: Text(
                    "stay away from extremes like, 1 Rep Sets with tons of weight, and 20+ Rep Sets",
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  content: Text(
                    "don't exercise until failure, instead stop before it",
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  content: Text(
                    "use the joints full range of motion as long as doing so doesn't cause overextension",
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  content: Text(
                    "avoid locking your joints when the force can cause them to bend in the incorrect direction ",
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  content: Text(
                    "if you suspect you are injured, do not continue, go to a doctor",
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  content: Text(
                    "maintain good form at all times",
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  content: Text(
                    "take the appropriate break between sets",
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  content: Text(
                    "drink the right amount of water",
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  content: Text(
                    "eat the right amount and kind of food",
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}