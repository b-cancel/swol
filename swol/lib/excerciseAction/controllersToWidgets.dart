import 'package:flutter/material.dart';

Widget weightAndRepsToWidget(String weight, String reps){
  bool zeroWeight = (weight == "" || weight == "0");
  bool zeroReps = (reps == "" || reps == "0");

  //build
  return RichText(
    softWrap: false,
    text: TextSpan(
      style: TextStyle(
        color: Colors.black,
      ),
      children: [
        TextSpan(
          text: "You started recording a set where you lifted\n",
        ),
        //-------------------------Weight-------------------------
        TextSpan(
          text: (zeroWeight ? "Nothing" : weight),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: zeroWeight ? "" : " (lbs/kg)"
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
          text: " Reps\n",
        )
      ],
    ),
  );
}