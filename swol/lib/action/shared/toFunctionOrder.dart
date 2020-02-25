import 'package:swol/action/page.dart';

updateOrderOfIDs(List<double> functionIDToValue){
  //recalculate all the potential values for function order
  Map<double,List<int>> valueToFunctionIDs = new Map<double,List<int>>();
  for(int functionID = 0; functionID < 8; functionID++){
    double value = functionIDToValue[functionID];
    if(valueToFunctionIDs.containsKey(value) == false){
      valueToFunctionIDs[value] = new List();
    }
    valueToFunctionIDs[value].add(functionID);
  }

  //grab the keys and sort them
  List<double> values = valueToFunctionIDs.keys.toList();
  values.sort((b, a) => a.compareTo(b)); //largest to smallest

  //build up your ordered IDs
  List<int> orderedIDs = new List<int>(8);
  if(values.length == functionIDToValue.length){
    for(int i = 0; i < values.length; i++){
      double value = values[i];
      int id = valueToFunctionIDs[value].removeLast();
      orderedIDs[i] = id;
    }
  }
  else{ //we have duplicate results
    print("***********************EDGE CASE*****************");
    //TODO: handle case where we know why
    //case 1: when using recorded weight, and then recorded weight matches the last weight
    //case 2: when using recorded reps, and the recorded reps match the last reps
    //case 3: when usign rep target, and the rep target matches the last reps
    int position = 0;
    for(int index = 0; index < values.length; index++){
      double value = values[index];
      //grab all the indices with this value
      List<int> indices = valueToFunctionIDs[value];
      for(int i = 0; i < indices.length; i++){
        //add them in order
        orderedIDs[position] = indices[i];
        position++;
      }
    }
  }

  print(orderedIDs.toString());
  
  //set the value so all notifies get notified
  ExcercisePage.orderedIDs.value = orderedIDs;
}