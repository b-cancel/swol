import 'package:swol/action/page.dart';
import 'package:swol/other/functions/1RM&R=W.dart';

List<double> calcAllWeightsWithReps(int reps){
  List<double> functionIDToWeight = new List<double>(8);

  //recalculate all the potential values for function order
  Map<double,int> weightToFunctionID = new Map<double,int>();
  for(int functionID = 0; functionID < 8; functionID++){
    double weight = ToWeight.fromRepAnd1Rm(
      //rep target used
      reps, 
      //one rep max that uses the same function as below
      ExcercisePage.oneRepMaxes[
        functionID
      ], 
      //function index to use
      functionID,
    );

    //add to map
    functionIDToWeight[functionID] = weight;
    weightToFunctionID[weight] = functionID;
  }

  //grab the keys and sort them
  List<double> weights = weightToFunctionID.keys.toList();
  weights.sort((b, a) => a.compareTo(b));
  List<int> orderedIDs = new List<int>(8);
  for(int i = 0; i < weights.length; i++){
    double weight = weights[i];
    int id = weightToFunctionID[weight];
    orderedIDs[i] = id;
  }
  
  //set the value so all notifies get notified
  ExcercisePage.orderedIDs.value = orderedIDs;

  //update the goal by chosing from everything we
  return functionIDToWeight;
}