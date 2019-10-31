import 'package:flutter/material.dart';
import 'package:swol/learn/body.dart';
import 'package:swol/learn/reusableWidgets.dart';
import 'package:swol/sharedWidgets/informationDisplay.dart';

class RepTargetPopUp extends StatelessWidget {
  const RepTargetPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Rep Target",
      subtitle: "Not sure? Keep the default",
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "Select a ",
                    ),
                    TextSpan(
                      text: "rep target",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    TextSpan(
                      text: " for the ",
                    ),
                    TextSpan(
                      text: "training type",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    TextSpan(
                      text: " you are working towards"
                    ),
                  ]
                ),
              ),
            ),
            Theme(
              data: ThemeData.dark(),
              child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: ScrollableTrainingTypes(
                    lightMode: true,
                    highlightField: 3,
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}

class PredictionFormulasPopUp extends StatelessWidget {
  const PredictionFormulasPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Prediction Formulas",
      subtitle: "Not sure? Keep the default",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Although these formulas were originally used to calculate an individual's 1 rep max\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "You can also use them to determine what your next set should be\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "In other words, they can give you a realistic goal to push towards",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Assming that you have both\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "1. Kept proper form",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "2. And taken an appropiate break between sets",
              ),
            ),
            new MyDivider(),
            //
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Which formula works best, depends on"
                  + " how much your nervous system is limiting you" 
                  + " in each individual excercise",
              ),
            ),
            new MyDivider(),
            //
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "In general \n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Exercises that use MORE muscle will put MORE strain on your nervous system\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Exercises that use LESS muscle will put LESS strain on your nervous system",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AutoUpdatePopUp extends StatelessWidget {
  const AutoUpdatePopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Auto Update",
      subtitle: "Not sure? Keep the default",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Which formula works best, depends on"
                  + " how much your nervous system is limiting you" 
                  + " in each individual excercise",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "But the forumla you chose initally, might not be predicting your results",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Because your nervous system is limiting you more or less than expected",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "By enabling this, you allow the app to switch to a formula that matches your results after each set",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "So you can have a more realistic goal to push towards",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SetTargetPopUp extends StatelessWidget {
  const SetTargetPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Set Target",
      subtitle: "Not sure? Keep the default",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "When you workout, it can be easy to forget how many sets you have left",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "So we help you track them!",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "In general\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "The MORE reps you are doing per set",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "the LESS sets you should be doing\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "The LESS reps you are doing per set",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "the MORE sets you should be doing",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SetBreakPopUp extends StatelessWidget {
  const SetBreakPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Recovery Time",
      subtitle: "Not sure? Keep the default",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "To select the appropiate recovery time\n"
                  ),
                ),
                ListItem(
                  circleColor: Colors.blue,
                  circleText: "1",
                  circleTextColor: Colors.white,
                  circleTextSize: 18,
                  circlePadding: 0,
                  content: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "Select the ",
                        ),
                        TextSpan(
                          text: "training type",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        TextSpan(
                          text: " you are working towards"
                        ),
                      ]
                    ),
                  ),
                ),
                ListItem(
                  circleColor: Colors.blue,
                  circleText: "2",
                  circleTextColor: Colors.white,
                  circleTextSize: 18,
                  circlePadding: 0,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "Select a ",
                            ),
                            TextSpan(
                              text: "larger recovery time ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "within the training type's range",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              )
                            ),
                            TextSpan(
                              text: " if you are working with ",
                            ),
                            TextSpan(
                              text: "larger muscle groups\n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "Select a ",
                            ),
                            TextSpan(
                              text: "smaller recovery time ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "within the training type's range",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              )
                            ),
                            TextSpan(
                              text: " if you are working with ",
                            ),
                            TextSpan(
                              text: "smaller muscle groups",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Theme(
            data: ThemeData.dark(),
            child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: ScrollableTrainingTypes(
                  lightMode: true,
                  highlightField: 2,
                ),
              ),
          ),
        ],
      ),
    );
  }
}

class ReferenceLinkPopUp extends StatelessWidget {
  const ReferenceLinkPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Reference Link",
      subtitle: "Copy and paste",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "It's helpful to have a resource at hand\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Link a video or image of the proper form, or anything else that might help",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExcerciseNotePopUp extends StatelessWidget {
  const ExcerciseNotePopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Excercise Note",
      subtitle: "Details",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "A space for any extra details",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExcerciseNamePopUp extends StatelessWidget {
  const ExcerciseNamePopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyInfoDialog(
      title: "Excercise Name",
      subtitle: "Choose a unique name",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "You can have ",
                  ),
                  TextSpan(
                    text: "multiple excercises",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " with the ",
                  ),
                  TextSpan(
                    text: "same name\n",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              ),
            ),
            //---
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "But, it's best",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " if you keep the name ",
                  ),
                  TextSpan(
                    text: "unique\n",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              ),
            ),
            //---
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "Especially",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " when you do the "
                    + "same excercise, multiple times, in the same workout"
                    + " but with a ",
                  ),
                  TextSpan(
                    text: "different",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
              ),
              child: Column(
                children: <Widget>[
                  ListItem(
                    circleColor: Colors.blue,
                    circleText: "1",
                    circleTextSize: 18,
                    circleTextColor: Colors.white,
                    content: Text("Previous Set"),
                  ),
                  ListItem(
                    circleColor: Colors.blue,
                    circleText: "2",
                    circleTextSize: 18,
                    circleTextColor: Colors.white,
                    content: Text("Desired Effort Level"),
                  ),
                  ListItem(
                    circleColor: Colors.blue,
                    circleText: "3",
                    circleTextSize: 18,
                    circleTextColor: Colors.white,
                    content: Text("Ability Formula"),
                  ),
                  ListItem(
                    circleColor: Colors.blue,
                    circleText: "4",
                    circleTextSize: 18,
                    circleTextColor: Colors.white,
                    content: Text("Rep Target"),
                  )
                ],
              ),
            )
            /*
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Although the you can have multiple excercises with the same name\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Extra details should be placed in notes", sdfsd
              ),
            ),
            */
          ],
        ),
      ),
    );
  }
}

/*
BASIC TEMPLATE
RichText(
  text: TextSpan(
    style: TextStyle(
      color: Colors.black,
    ),
    children: [
      TextSpan(
        text: "bold text",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: " non bold text ",
      ),
    ]
  ),
),
*/