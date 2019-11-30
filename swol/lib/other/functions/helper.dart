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

  static List<int> getOneRepMaxValues(int weight, int reps, int functionIndex){
    List<double> possibleOneRepMaxes = new List<double>();
    for(int i = 0; i < 8; i++){
      double oneRepMax = To1RM.fromWeightAndReps(
        weight.toDouble(), 
        reps.toDouble(), 
        i,
      );
      possibleOneRepMaxes.add(oneRepMax);
    }
    double theMean = getMean(possibleOneRepMaxes);
    double stdDeviation = getStandardDeviation(possibleOneRepMaxes, mean: theMean);

    return [possibleOneRepMaxes[functionIndex].toInt(), stdDeviation.toInt()];
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