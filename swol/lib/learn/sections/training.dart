import 'package:flutter/material.dart';
import 'package:swol/learn/shared.dart';
import 'package:swol/sharedWidgets/trainingTypes/trainingTypes.dart';

class TrainingBody extends StatelessWidget {
  const TrainingBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionDescription(
          children: [
            TextSpan(
              text: "There are many reasons you may want to workout\nBut ",
            ),
            TextSpan(
              text: "you should have One Primary Goal ",
              style: TextStyle(
                fontWeight: FontWeight.w900,
              )
            ),
          ],
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
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: "Do you want to ",
                        ),
                        TextSpan(
                          text: "\tGet Strong\t",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                        ),
                        TextSpan(
                          text: ", ",
                        ),
                        TextSpan(
                          text: "\tGet Big\t",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                        ),
                        TextSpan(
                          text: ", or",
                        ),
                        TextSpan(
                          text: "\tGet Agile\t",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                      ),
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
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: "To Get Strong\t",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
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
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: "To Get Big\t",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
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
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: "To Get Agile\t",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          TextSpan(
                            text: ", Use Endurance Training",
                          ),
                        ],
                      ),
                    ),
                    bottomSpacing: 0,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: "\nThe chart below has a column for each type of training. ",
                        ),
                        TextSpan(
                          text: "Sticking to a training style will give you the fastest results.\n",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
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
    );
  }
}