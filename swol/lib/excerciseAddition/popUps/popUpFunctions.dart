import 'package:flutter/material.dart';
import 'package:swol/excerciseAddition/popUps/nameBody.dart';
import 'package:swol/sharedWidgets/informationDisplay.dart';

Function excerciseNamePopUp(BuildContext context){
  return (){
    return infoPopUpFunction(
      context, 
      title: "Excercise Name",
      subtitle: "Choose a unique name",
      body: ExcerciseNamePopUpBody(),
    );
  };
}