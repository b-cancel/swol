import 'package:flutter/material.dart';

Widget weightAndRepsToDescription(String weight, String reps, {bool isError: false}){
  bool zeroWeight = (weight == "" || weight == "0");
  bool zeroReps = (reps == "" || reps == "0");
  String weightS = (weight != "1") ? "s" : "";
  String repsS = (reps != "1") ? "s" : "";

  //build
  return RichText(
    softWrap: false,
    text: TextSpan(
      style: TextStyle(
        color: Colors.black,
      ),
      children: [
        TextSpan(
          text: isError ? "You are trying to record a set where you lifted" : "You started recording a set where you lifted",
        ),
        //-------------------------Weight-------------------------
        TextSpan(
          text: "\n" + (zeroWeight ? "Nothing" : weight),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: zeroWeight ? "" : " (lb" + weightS + "/kg" + weightS + ")"
        ),
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
          text: " Rep" + repsS +"\n",
        )
      ],
    ),
  );
}

weightAndRepsToProblem(bool weightValid, bool repsValid, {bool isError: false}){
  bool setValid = weightValid && repsValid;
  //build
  return Visibility(
    visible: setValid == false,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Visibility(
          visible: weightValid == false,
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: "But for body weight excercises you should instead ",
                ),
                TextSpan(
                  text: "record your body weight" 
                  //for warning "new line"
                  //for error if alone "new line"
                  //for error if not alone ""
                  + ((isError && repsValid == false) ? "" : "\n"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: repsValid == false,
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              children: [
                //for warning "But a set"
                //for error if alone "But a set"
                //for error if not alone "And a set"
                TextSpan(
                  text: ((isError && weightValid == false ? ", and" : "But"))
                  + " a set requires",
                ),
                TextSpan(
                  text: " atleast 1 rep\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}