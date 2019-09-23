import 'package:flutter/material.dart';
import 'package:swol/helpers/addWorkout.dart';

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
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Different quantity of reps help you focus on different things",
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
      title: "Set Break",
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
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "You need to give your muscles time to recover!"
              ),
            ),
            MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Exactly how much rest depends\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "1. How you specifically want to improve",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "2. And how much muscle this particular excercise uses",
              ),
            ),
            MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "In general \n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Exercises that use MORE muscle will require LONGER breaks\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Exercises that use LESS muscle will require SHORTER breaks",
              ),
            ),
          ],
        ),
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
      subtitle: "Copy and paste from web browser",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Form is incredibly important!"
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Especially as you're approaching your 1 rep max, if your form isn't perfect, you could get permanently injured",
              ),
            ),
            new MyDivider(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "So it's a good idea to keep a link to a video or picture of the proper form of each excercise",
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
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Here you can write in details like: \n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "1. Preferred grip",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "2. Modifications you made to form",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "3. Etc...",
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
      subtitle: "Unique Name",
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Don't worry about adding too many details here\n",
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Extra details should be placed in notes",
              ),
            ),
          ],
        ),
      ),
    );
  }
}