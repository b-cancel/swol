import 'package:swol/other/functions/W&R=1RM.dart';
import 'dart:math' as math;

class Functions{
  static const int defaultFunctionIndex = 4; 

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

  //TODO: one rep max of 1 rep is well... already calculated
  //NOTE: returns array with [0] all 1 rep maxes, [1] theMean, [2] stdDeviation 
  static List getOneRepMaxValues(int weight, int reps, {bool onlyIfNoBackUp: true}){
    List<double> possibleOneRepMaxes = new List<double>();
    List<double> possibleDifferentFunctionOneRepMaxes = new List<double>();
    for(int i = 0; i < 8; i++){
      double oneRepMax = To1RM.fromWeightAndReps(
        weight.toDouble(), 
        reps.toDouble(), 
        i,
      );

      //add all
      possibleOneRepMaxes.add(oneRepMax);

      if(onlyIfNoBackUp){
        bool usingBackUpFunction = true;

        //if we are using one of the 3 functions that use backups, make sure we aren't going to
        if(i == 0 && To1RM.brzyckiUsefull(reps.toDouble())) usingBackUpFunction = false;
        else if(i == 1 && To1RM.mcGlothinOrLandersUsefull(reps.toDouble())) usingBackUpFunction = false;
        else if(i == 2 && To1RM.almazanUsefull(reps.toDouble())) usingBackUpFunction = false;
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
}