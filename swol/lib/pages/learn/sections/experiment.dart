//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/simple/functionTable.dart';
import 'package:swol/shared/widgets/simple/listItem.dart'; 
import 'package:swol/pages/learn/description.dart';

//widget
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
                /*
                One Rep Max Formulas predict your One Rep Max based on any other set.
                But every formula gives different results.
                And the difference between the results grows as you do more reps.

                1. So we automatically calculate your Estimated One Rep Max (E-1RM) for every excercise
                and give you a measure of how sure you can be about this estimate
                based on how different the results from all the formulas are

                Additionally, some formulas have limits, 
                for example the "Brzycki Formula" 
                can't give you a One Rep Max Estimate 
                if you do more than 37 rep

                2. So we automatically switch to the formula 
                that most closely matches the selected one in the background, 
                its just one less thing to worry about!

                We also beleive that if the formulas can predict your One Rep Max based on any other
                then they should also be able to predict any other set based on your One Rep Max

                3. So before the begining of every set, 
                we grab your last set, calculate your one rep max,
                and then use your rep target, to calculate what your body should be able to lift

                This helps you always workout at your desired rep target
                and know exactly what weight to grab without having to do any guesswork
                and without following some routine that may be too much or too little for you

                SWOL equips you with the math you need to listen to your body,
                and adjust your workouts on the fly,
                to always improve as fast as possible without injuring yourself
                */
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  circleText: "1",
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
                  content: Text(
                    "your previous set ",
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  circleText: "2",
                  content: Text(
                    "your prefered or suggested ability formula",
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  circleText: "3",
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
                Padding(
                  padding: EdgeInsets.only(
                    top: 24,
                    bottom: 8,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: FunctionCardTable(
                      cardBackground: true,
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