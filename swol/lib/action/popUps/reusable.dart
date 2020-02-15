import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/structs/anExcercise.dart';

//widgets reused in multiple pop ups
class SetTitle extends StatelessWidget {
  const SetTitle({
    Key key,
    @required this.title,
    @required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ]
    );
  }
}

class SetDescription extends StatelessWidget {
  SetDescription({
    @required this.weight,
    @required this.reps,
    this.isError: false,
  });

  final String weight;
  final String reps;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    bool zeroWeight = (weight == "" || weight == "0");
    bool zeroReps = (reps == "" || reps == "0");
    String weightS = (weight != "1") ? "s" : "";
    String repsS = (reps != "1") ? "s" : "";

    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
        ),
        children: [
          TextSpan(
            //TODO: perhaps update this message different for all the condition
            //error & new
            //error & update
            //not error & new
            //not error & update
            text: (isError
                    ? "You are trying to record"
                    : "You started recording") +
                " a set, where you lifted ",
          ),
          //-------------------------Weight-------------------------
          TextSpan(
            text: (zeroWeight ? "Nothing" : weight),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
              text: zeroWeight ? "" : " (lb" + weightS + "/kg" + weightS + ")"),
          //-------------------------Reps-------------------------
          TextSpan(
            text: " for ",
          ),
          TextSpan(
            text: zeroReps ? "Zero" : reps,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: " Rep" + repsS + "\n",
          )
        ],
      ),
    );
  }
}

class SetProblem extends StatelessWidget {
  SetProblem({
    @required this.weightValid,
    @required this.repsValid,
    @required this.setValid,
    this.isError: false,
  });

  final bool weightValid;
  final bool repsValid;
  final bool setValid;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: setValid == false,
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: (weightValid)
                  ? ""
                  : "But for body weight excercises you should instead ",
            ),
            TextSpan(
              text: (weightValid)
                  ? ""
                  : ("record your body weight"
                      //for warning "new line"
                      //for error if alone "new line"
                      //for error if not alone ""
                      +
                      ((isError && repsValid == false) ? "" : "\n")),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            //for warning "But a set"
            //for error if alone "But a set"
            //for error if not alone "And a set"
            TextSpan(
              text: (repsValid)
                  ? ""
                  : (((isError && weightValid == false ? ", and" : "But")) +
                      " a set requires"),
            ),
            TextSpan(
              text: (repsValid) ? "" : " atleast 1 Rep\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoBackAndFix extends StatelessWidget {
  const GoBackAndFix({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: "If you don't ",
          ),
          TextSpan(
            text: "Fix Your Set",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ", this information will be lost. ",
          ),
          TextSpan(
            text: "Would you like to ",
          ),
          TextSpan(
            text: "Go Back",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: " and Fix Your Set?",
          ),
        ],
      ),
    );
  }
}

class RevertToPrevious extends StatelessWidget {
  const RevertToPrevious({
    Key key,
    @required this.excercise,
  }) : super(key: key);

  final AnExcercise excercise;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "\nor "),
          TextSpan(
            text: "Revert",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: " back to, ",
          ),
          TextSpan(
            text: excercise.tempWeight.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: " for ",
          ),
          TextSpan(
            text: excercise.tempReps.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: "rep" +
                (excercise.tempReps == 1 ? "" : "s"),
          ),
        ],
      ),
    );
  }
}