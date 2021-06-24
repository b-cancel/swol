import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/action/popUps/textValid.dart';

//widgets reused in multiple pop ups
class SetDescription extends StatelessWidget {
  SetDescription({
    required this.weight,
    required this.reps,
    this.isError: false,
  });

  final String weight;
  final String reps;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    bool invalidWeight = isTextValid(weight) == false;
    bool invalidReps = isTextValid(reps) == false;
    String weightS = (weight != "1") ? "s" : "";
    String repsS = (reps != "1") ? "s" : "";

    return RichText(
      textScaleFactor: MediaQuery.of(
        context,
      ).textScaleFactor,
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
        ),
        children: [
          TextSpan(
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
            text: invalidWeight
                ? ((weight.length == 0 || weight == "0")
                    ? "Nothing"
                    : "An Invalid Amount of Weight")
                : weight,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
              text: invalidWeight
                  ? ""
                  : " (lb" + weightS + "/kg" + weightS + ")"),
          //-------------------------Reps-------------------------
          TextSpan(
            text: " for ",
          ),
          TextSpan(
            text: invalidReps
                ? ((reps.length == 0 || reps == "0")
                    ? "Zero"
                    : "An Invalid Amount of Reps")
                : reps,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: (invalidReps ? "" : " Rep" + repsS) + "\n",
          )
        ],
      ),
    );
  }
}

class SetProblem extends StatelessWidget {
  SetProblem({
    required this.weightValid,
    required this.repsValid,
    required this.setValid,
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
        textScaleFactor: MediaQuery.of(
          context,
        ).textScaleFactor,
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: (weightValid)
                  ? ""
                  : "But for body weight exercises you should instead ",
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textScaleFactor: MediaQuery.of(
        context,
      ).textScaleFactor,
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
    Key? key,
    required this.exercise,
  }) : super(key: key);

  final AnExercise exercise;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textScaleFactor: MediaQuery.of(
        context,
      ).textScaleFactor,
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
        ),
        children: [
          TextSpan(text: "or "),
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
            //we KNOW any widget that calls this has VALID tempWeight
            text: exercise.tempWeight.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: " for ",
          ),
          TextSpan(
            //we KNOW any widget that calls this has VALID tempReps
            text: exercise.tempReps.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            //we KNOW any widget that calls this has VALID tempReps
            text: " rep" + (exercise.tempReps == 1 ? "" : "s"),
          ),
        ],
      ),
    );
  }
}
