import 'dart:collection';

import 'package:swol/other/functions/W&R=1RM.dart';
import 'dart:math' as math;

class Functions{
  //r: must not be 37 (for sure)
  //r: must not be anything above 37 (logically)
  static bool brzyckiUsefull(double reps) => (reps < 37);

  //r: must not be 37.9226049423 (technically)
  //r: must not be anything above 37.9226049423 (logically)
  //r: and logically you can assume the number is 38 
  //    1. because we are only ever going to be passed int reps
  //    2. and because 37 actually does work here whereas 38 does not
  static bool mcGlothinOrLandersUsefull(double reps) => (reps < 38);

  //r: must not be 104.34355 (technically)
  //r: must not anything above 104.34355 (logically)
  //r: and logically youc an assume the number is 105
  //    1. because we are only ever going to be passed int reps
  //    2. and because 104 does work here whereas 105 does not
  static bool almazanUsefull(double reps) => (reps < 105);

  //based on average order of functions
  static const int defaultFunctionIndex = 3; 

  static List<String> functions = [
    "Brzycki Formula", // 0
    "McGlothin (or Landers) Formula", // 1
    "Almazan Formula", // 2
    "Epley (or Baechle) Formula", // 3
    "O'Conner Formula", // 4
    "Wathan Formula", // 5
    "Mayhew Formula", // 6
    "Lombardi Formula", // 7
  ];

  static Map<String, int> functionToIndex = {
    functions[0] : 0,
    functions[1] : 1,
    functions[2] : 2,
    functions[3] : 3,
    functions[4] : 4,
    functions[5] : 5,
    functions[6] : 6,
    functions[7] : 7,
  };

  //NOTE: returns array with [0] all 1 rep maxes, [1] theMean, [2] stdDeviation 
  static List getOneRepMaxValues(int weight, int reps, {bool onlyIfNoBackUp: true}){
    List<double> possibleOneRepMaxes = new List<double>();
    List<double> possibleDifferentFunctionOneRepMaxes = new List<double>();
    for(int functionID = 0; functionID < 8; functionID++){
      double oneRepMax = To1RM.fromWeightAndReps(
        weight.toDouble(), 
        reps.toDouble(), 
        functionID,
      );

      //add all
      possibleOneRepMaxes.add(oneRepMax);

      if(onlyIfNoBackUp){
        bool usingBackUpFunction = true;

        //if we are using one of the 3 functions that use backups, make sure we aren't going to
        if(functionID == 0 && brzyckiUsefull(reps.toDouble())) usingBackUpFunction = false;
        else if(functionID == 1 && mcGlothinOrLandersUsefull(reps.toDouble())) usingBackUpFunction = false;
        else if(functionID == 2 && almazanUsefull(reps.toDouble())) usingBackUpFunction = false;
        else usingBackUpFunction = false; //any function without a limit
        
        //add only those that didn't use a back up function
        if(usingBackUpFunction == false){
          possibleDifferentFunctionOneRepMaxes.add(oneRepMax);
        }
      }
    }

    //calculate the mean and std dev
    double theMean = getMean(
      (onlyIfNoBackUp) ? possibleDifferentFunctionOneRepMaxes : possibleOneRepMaxes,
    );

    double stdDeviation = getStandardDeviation(
      (onlyIfNoBackUp) ? possibleDifferentFunctionOneRepMaxes : possibleOneRepMaxes, 
      mean: theMean,
    );

    //NOTE: this must still return all the results
    return [possibleOneRepMaxes, theMean, stdDeviation];
  }

  static double getMean(List<double> values){
    double sum = 0;
    for(int i = 0 ; i < values.length; i++){
      sum += values[i];
    }
    return sum/values.length;
  }

  static double getStandardDeviation(List<double> values ,{double mean}){
    if(mean == null) mean = getMean(values);

    double massiveSum = 0;
    for(int i = 0; i < values.length; i++){
      double val = values[i] - mean;
      massiveSum += (val * val);
    }

    return math.sqrt(massiveSum / values.length);
  }

  static List<int> orderIndices(List<double> list){
    HashMap<double,int> valueToIndex = new HashMap<double,int>();
    for(int i = 0; i < list.length; i++){
      valueToIndex[list[i]] = i;
    }
    list.sort();
    List<int> sortedIndices = new List<int>(list.length);
    for(int i = 0; i < list.length; i++){
      sortedIndices[i] = valueToIndex[list[i]];
    }
    return sortedIndices;
  }
}