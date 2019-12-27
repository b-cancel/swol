//flutter
import 'package:flutter/material.dart';
import 'package:swol/excerciseAddition/popUps/bodies/littleBodies.dart';
import 'package:swol/excerciseAddition/popUps/bodies/predictionBody.dart';
import 'package:swol/excerciseAddition/popUps/bodies/recoveryTimeBody.dart';
import 'package:swol/excerciseAddition/popUps/bodies/repTargetBody.dart';
import 'package:swol/excerciseAddition/popUps/bodies/setTargetBody.dart';

//internal shared
import 'package:swol/sharedWidgets/informationDisplay.dart';

//internal bodies
import 'package:swol/excerciseAddition/popUps/bodies/nameBody.dart';

//widgets
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

Function excerciseNotePopUp(BuildContext context){
  return (){
    return infoPopUpFunction(
      context, 
      title: "Excercise Note",
      subtitle: "Details",
      body: ExcerciseNotePopUpBody(),
    );
  };
}

Function referenceLinkPopUp(BuildContext context){
  return (){
    return infoPopUpFunction(
      context, 
      title: "Reference Link",
      subtitle: "Copy and paste",
      body: ReferenceLinkPopUpBody(),
    );
  };
}

Function recoveryTimePopUp(BuildContext context){
  return (){
    return infoPopUpFunction(
      context, 
      title: "Recovery Time",
      subtitle: "Not sure? Keep the default",
      body: RecoveryTimePopUpBody(),
    );
  };
}

Function repTargetPopUp(BuildContext context){
  return (){
    return infoPopUpFunction(
      context, 
      title: "Rep Target",
      subtitle: "Not sure? Keep the default",
      body: RepTargetPopUpBody(),
    );
  };
}

Function setTargetPopUp(BuildContext context){
  return (){
    return infoPopUpFunction(
      context, 
      title: "Set Target",
      subtitle: "Not sure? Keep the default",
      body: SetTargetPopUpBody(),
    );
  };
}

Function predictionFormulasPopUp(BuildContext context){
  return (){
    return infoPopUpFunction(
      context, 
      title: "Prediction Formulas",
      subtitle: "Not sure? Keep the default",
      body: PredictionFormulasPopUpBody(),
    );
  };
}