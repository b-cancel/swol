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
    TextStyle defaul = TextStyle(
      fontSize: 16,
    );

    TextStyle bold = TextStyle(
      fontWeight: FontWeight.bold,
    );

    return Column(
      children: <Widget>[
        SectionDescription(
          children: [
            TextSpan(
              text:
                  "We suspect, that one rep max formulas can be helpful for more than just tracking your progress",
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        DefaultTextStyle(
          style: TextStyle(
            fontSize: 16,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /*
                One Rep Max Formulas predict your One Rep Max based on any other set.
                But every formula gives different results.
                And the difference between the results grows as you do more reps.

                1. So we automatically calculate your Estimated One Rep Max (E-1RM) for every exercise
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
                RichText(
                  textScaleFactor: MediaQuery.of(
                    context,
                  ).textScaleFactor,
                  text: TextSpan(style: defaul, children: [
                    TextSpan(
                        text: "One Rep Max Formulas can predict" +
                            " your One Rep Max based on any other set.\n\nBut "),
                    TextSpan(
                      text: "every formula will give you different results.",
                      style: bold,
                    ),
                    TextSpan(
                      text: "\n\nAnd ",
                    ),
                    TextSpan(
                      text: "the difference",
                      style: bold,
                    ),
                    TextSpan(
                      text: " between those results ",
                    ),
                    TextSpan(
                      text: "will grow",
                      style: bold,
                    ),
                    TextSpan(
                      text: " as you do more reps. " +
                          "To work with that limitation we\n",
                    ),
                  ]),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  circleText: "1",
                  content: RichText(
                    textScaleFactor: MediaQuery.of(
                      context,
                    ).textScaleFactor,
                    text: TextSpan(
                      style: defaul,
                      children: [
                        TextSpan(
                          text: "Automatically Calculate",
                          style: bold,
                        ),
                        TextSpan(text: " your Estimated One Rep Max "),
                        TextSpan(
                          text: "(E-1RM)",
                          style: bold,
                        ),
                        TextSpan(
                          text: " for every excercise, and" +
                              " give you an idea of ",
                        ),
                        TextSpan(
                          text: "how sure you can be about this estimate",
                          style: bold,
                        ),
                        TextSpan(
                          text:
                              " based on how different the results from all the formulas are",
                        ),
                      ],
                    ),
                  ),
                ),
                RichText(
                  textScaleFactor: MediaQuery.of(
                    context,
                  ).textScaleFactor,
                  text: TextSpan(
                    style: defaul,
                    children: [
                      TextSpan(
                        text: "But in order to do that ",
                      ),
                      TextSpan(
                        text: "we have to address the limits",
                        style: bold,
                      ),
                      TextSpan(text: " of each formula.\n\n"),
                      TextSpan(
                        text: "For Example,",
                        style: bold,
                      ),
                      TextSpan(
                          text: " the Brzycki Formula can't give you a One Rep Max Estimate" +
                              " if the set being used to do that math has more than 36 reps." +
                              " To work with that limitation we\n"),
                    ],
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  circleText: "2",
                  content: RichText(
                    textScaleFactor: MediaQuery.of(
                      context,
                    ).textScaleFactor,
                    text: TextSpan(
                      style: defaul,
                      children: [
                        TextSpan(
                          text: "Automatically Switch",
                          style: bold,
                        ),
                        TextSpan(
                            text:
                                " to the next closest formula in the background"),
                      ],
                    ),
                  ),
                ),
                RichText(
                  textScaleFactor: MediaQuery.of(
                    context,
                  ).textScaleFactor,
                  text: TextSpan(
                    style: defaul,
                    children: [
                      TextSpan(
                        text: "Additionally, we beleive",
                        style: bold,
                      ),
                      TextSpan(
                          text:
                              " that if the formulas can predict your one rep max" +
                                  " based on any other set, then"),
                      TextSpan(
                        text: " they should be able to predict" +
                            " any other set based on your one rep max\n",
                        style: bold,
                      ),
                    ],
                  ),
                ),
                ListItem(
                  circleColor: Theme.of(context).accentColor,
                  circleText: "3",
                  content: RichText(
                    textScaleFactor: MediaQuery.of(
                      context,
                    ).textScaleFactor,
                    text: TextSpan(
                      style: defaul,
                      children: [
                        TextSpan(
                            text: "So before beginning your set," +
                                " we grab your last set," +
                                " calculate your one rep max" +
                                " using the selected formula, " +
                                " and then use your rep target, to "),
                        TextSpan(
                          text:
                              "Calculate what your body should be able to lift",
                          style: bold,
                        ),
                      ],
                    ),
                  ),
                ),
                RichText(
                  textScaleFactor: MediaQuery.of(
                    context,
                  ).textScaleFactor,
                  text: TextSpan(
                    style: defaul,
                    children: [
                      TextSpan(
                        text: "This is going to help you ",
                      ),
                      TextSpan(
                        text: "stay at your desired rep target" +
                            " and know exactly what weight to grab",
                        style: bold,
                      ),
                      TextSpan(
                        text: " without having to do any guesswork",
                      ),
                      TextSpan(
                          text: " and without following some routine" +
                              " that may be too easy or too hard on you.\n\n"),
                      //-------------------------
                      TextSpan(
                        text: "SWOL",
                        style: bold,
                      ),
                      TextSpan(
                        text: " makes it possible for you to ",
                      ),
                      TextSpan(
                        text: "Listen To Your Body",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " and ",
                      ),
                      TextSpan(
                        text: "Make Adjustements On The Fly",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " in order to ",
                      ),
                      TextSpan(
                        text:
                            "Improve as fast as possible without injuring yourself",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 24,
            bottom: 8,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: FunctionCardTable(
              cardBackground: true,
            ),
          ),
        ),
      ],
    );
  }
}
