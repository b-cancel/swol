import 'package:flutter/material.dart';
import 'package:swol/learn/shared.dart';
import 'package:swol/sharedWidgets/trainingTypes/trainingTypes.dart';

class TrainingBody extends StatelessWidget {
  const TrainingBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          SectionDescription(
            child: Text(
              "There are many reasons you may want to workout"
              + "\nBut everyone has 1 Primary Goal",
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "They either want to ",
                          ),
                          TextSpan(
                            text: " Get Strong ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ", ",
                          ),
                          TextSpan(
                            text: " Get Big ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ", or",
                          ),
                          TextSpan(
                            text: " Get Agile ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "\nEach goal has its own training type.\n",
                          ),
                        ],
                      ),
                    ),
                    ListItem(
                      circleColor: Theme.of(context).accentColor,
                      content: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "To Get Strong",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ", Use Strength Training",
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListItem(
                      circleColor: Theme.of(context).accentColor,
                      content: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "To Get Big",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ", Use Hypertrophy Training",
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListItem(
                      circleColor: Theme.of(context).accentColor,
                      content: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "To Get Agile",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ", Use Endurance Training",
                            ),
                          ],
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "\nThe chart below has a column for each type of training.\n"
                            + "Sticking to a training style will give you the fastest results.\n",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Theme(
                data: ThemeData.dark().copyWith(
                  primaryColor: Theme.of(context).primaryColor,
                  primaryColorDark: Theme.of(context).cardColor,
                  cardColor: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: AllTrainingTypes(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}