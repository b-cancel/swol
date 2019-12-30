import 'package:flutter/material.dart';
import 'package:swol/learn/shared.dart'; 

class ExperimentBody extends StatelessWidget {
  const ExperimentBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionDescription(
          children: [
            TextSpan(
              text: "We suspect, that one rep max formulas can be helpful for more than just tracking your progress",
              style: TextStyle(
                fontWeight: FontWeight.w900,
              )
            ),
          ],
        ),
        DefaultTextStyle(
          style: TextStyle(
            fontSize: 16,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Based on our limited experience and experimentation we believe\n",
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  circleText: "1",
                  circleTextSize: 18,
                  content: Text(
                    "The "
                    + "ABILITY"
                    + " of a set of muscles is the "
                    + "maximum amount of weight"
                    + " they can lift at "
                    + "all rep range"
                    + " targets (below 35)",
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  circleText: "2",
                  circleTextSize: 18,
                  content: Text(
                    "The "
                    + "ABILITY"
                    + " of a set of muscles can therefore be "
                    + "represented by a formula"
                    + " (one of the one rep max formulas)",
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  circleText: "3",
                  circleTextSize: 18,
                  content: Text(
                    "Additionally, the "
                    + "ABILITY"
                    + " of a set of muscles does not just "
                    + "depend"
                    + " on how strong those muscles are, but "
                    + "also on how much of them you can voluntarily activate",
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  circleText: "4",
                  circleTextSize: 18,
                  content: Text(
                    "Furthermore, because you need "
                    + "different amounts of control"
                    + " over your entire nervous system "
                    + "for different exercises, different ABILITY formulas will be used for different exercises"
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  circleText: "5",
                  circleTextSize: 18,
                  content: Text(
                    "We believe that "
                    + "what ABILITY formula each exercise uses, indicates "
                    + "to what extent you can voluntarily activate your muscles due to "
                    + "your overall level of nervous system control"
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  circleText: "6",
                  circleTextSize: 18,
                  content: Text(
                    "So as you continue to train, the "
                    + "ABILITY formulas that each exercise uses should change to reflect an overall increase in the control"
                    + " you have over your entire nervous system"
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: "If we make these assumptions, for each exercise,",
                      ),
                      TextSpan(
                        text: "we can ",
                      ),
                      TextSpan(
                        text: "\tuse the 1RM formulas to give you a goal to work towards\t",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " for your next set by using\n",
                      ),
                    ],
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  circleText: "1",
                  circleTextSize: 18,
                  content: Text(
                    "your previous set ",
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  circleText: "2",
                  circleTextSize: 18,
                  content: Text(
                    "your prefered or suggested ability formula",
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  circleText: "3",
                  circleTextSize: 18,
                  content: Text(
                    "and your rep target",
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: "As new sets are recorded ",
                      ),
                      TextSpan(
                        text: "\twe can also switch to a formula that more accurately reflects your results\n\n",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //-------------------------
                      TextSpan(
                        text: "We believe this will help you ",
                      ),
                      TextSpan(
                        text: "\timprove as fast as possible, regardless of what type of training\t",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " you are using, ",
                      ),
                      TextSpan(
                        text: "\twithout getting injured\n\n",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //-------------------------
                      TextSpan(
                        text: "Below is a chart of all the ",
                      ),
                      TextSpan(
                        text: "\tAbility Formulas\t",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ", previously known as ",
                      ),
                      TextSpan(
                        text: "\t1 Rep Max Formulas\t",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ", and what level of "
                      ),
                      TextSpan(
                        text: "\tlimitation they imply\t",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 8,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: FunctionCardTable(
                      context: context,
                      otherDark: true,
                    ),
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

class FunctionCardTable extends StatelessWidget {
  FunctionCardTable({
    @required this.context,
    this.isDark: true,
    this.otherDark: false,
  });

  final BuildContext context;
  final bool isDark;
  final bool otherDark;

  List<Widget> buildFields(List<String> items){
    List<Widget> buildFields = new List<Widget>();

    for(int i = 0; i < items.length; i++){
      Color fieldColor;
      if(i == 0) fieldColor = (isDark) ? Theme.of(context).accentColor : Colors.blue;
      else{
        if(i%2==0) fieldColor = otherDark ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).cardColor;
        else fieldColor = Theme.of(context).primaryColor;
      }

      buildFields.add(
        Container(
          color: fieldColor,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 8,
              ),
              child: Text(
                items[i],
                style: TextStyle(
                  color: (i == 0) 
                  ? ((isDark) ? Colors.black : Colors.white) 
                  : Colors.white,
                  fontWeight: (i == 0) ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return buildFields;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Row(
        children: <Widget>[
          Container(
            color: Theme.of(context).cardColor,
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: buildFields([
                  "Limitation Level",
                  "8 BEGINNER",
                  "7",
                  "6",
                  "5",
                  "4 AVG",
                  "3",
                  "2",
                  "1 PRO",
                ]),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).cardColor,
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buildFields([
                    "Ability Formulas",
                    "Brzycki",
                    "McGlothin (or Landers)",
                    "Almazan *our own*",
                    "Epley (or Baechle)",
                    "O`Conner",
                    "Wathan",
                    "Mayhew",
                    "Lombardi",
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}