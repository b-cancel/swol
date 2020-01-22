//flutter
import 'package:flutter/material.dart';

//internal: addition
import 'package:swol/excerciseAddition/popUps/bodies/littleBodies.dart';
import 'package:swol/excerciseAddition/popUps/bodies/predictionBody.dart';
import 'package:swol/excerciseAddition/popUps/bodies/recoveryTimeBody.dart';
import 'package:swol/excerciseAddition/popUps/bodies/repTargetBody.dart';
import 'package:swol/excerciseAddition/popUps/bodies/setTargetBody.dart';

//internal: other
import 'package:swol/shared/widgets/complex/learnPopUp/ourInformationPopUp.dart';
import 'package:swol/excerciseAddition/popUps/bodies/nameBody.dart';

//widgets

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
    isDense: true,
  );
}