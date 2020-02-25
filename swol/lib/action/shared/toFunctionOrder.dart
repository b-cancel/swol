import 'package:swol/action/page.dart';

updateOrderOfIDs(List<double> functionIDToValue){
  //recalculate all the potential values for function order
  Map<double,int> valueToFunctionID = new Map<double,int>();
  for(int functionID = 0; functionID < 8; functionID++){
    double value = functionIDToValue[functionID];
    valueToFunctionID[value] = functionID;
  }

  //grab the keys and sort them
  List<double> values = valueToFunctionID.keys.toList();
  values.sort((b, a) => a.compareTo(b)); //largest to smallest
  List<int> orderedIDs = new List<int>(8);
  for(int i = 0; i < values.length; i++){
    double value = values[i];
    int id = valueToFunctionID[value];
    orderedIDs[i] = id;
  }

  print(orderedIDs.toString());
  
  //set the value so all notifies get notified
  ExcercisePage.orderedIDs.value = orderedIDs;
}