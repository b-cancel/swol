import 'package:swol/action/page.dart';

updateOrderOfIDs(List<double> functionIDToValue){
  print(functionIDToValue.toString() + " S");

  //recalculate all the potential values for function order
  Map<double,int> valueToFunctionID = new Map<double,int>();
  for(int functionID = 0; functionID < 8; functionID++){
    double value = functionIDToValue[functionID];
    valueToFunctionID[value] = functionID;
  }

  //grab the keys and sort them
  List<double> values = valueToFunctionID.keys.toList();
  values.sort((b, a) => a.compareTo(b)); //largest to smallest

  print(values.toString() + " M");

  List<int> orderedIDs = new List<int>(8);
  for(int i = 0; i < values.length; i++){
    double value = values[i];
    int id = valueToFunctionID[value];
    print(value.toString() + " => " + id.toString());
    orderedIDs[i] = id;
  }

  print(orderedIDs.toString() + " E");
  
  //set the value so all notifies get notified
  ExcercisePage.orderedIDs.value = orderedIDs;
}