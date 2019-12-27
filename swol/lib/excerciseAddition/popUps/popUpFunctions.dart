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
excerciseNamePopUp(BuildContext context){
  infoPopUpFunction(
    context, 
    title: "Excercise Name",
    subtitle: "Choose a unique name",
    body: ExcerciseNamePopUpBody(),
  );
}

excerciseNotePopUp(BuildContext context){
  infoPopUpFunction(
    context, 
    title: "Excercise Note",
    subtitle: "Details",
    body: ExcerciseNotePopUpBody(),
  );
}

referenceLinkPopUp(BuildContext context){
  infoPopUpFunction(
    context, 
    title: "Reference Link",
    subtitle: "Copy and paste",
    body: ReferenceLinkPopUpBody(),
  );
}

recoveryTimePopUp(BuildContext context){
  infoPopUpFunction(
    context, 
    title: "Recovery Time",
    subtitle: "Not sure? Keep the default",
    body: RecoveryTimePopUpBody(),
  );
}

repTargetPopUp(BuildContext context){
  infoPopUpFunction(
    context, 
    title: "Rep Target",
    subtitle: "Not sure? Keep the default",
    body: RepTargetPopUpBody(),
  );
}

setTargetPopUp(BuildContext context){
  infoPopUpFunction(
    context, 
    title: "Set Target",
    subtitle: "Not sure? Keep the default",
    body: SetTargetPopUpBody(),
  );
}

predictionFormulasPopUp(BuildContext context){
  infoPopUpFunction(
    context, 
    title: "Prediction Formulas",
    subtitle: "Not sure? Keep the default",
    body: PredictionFormulasPopUpBody(),
  );
}