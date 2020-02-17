import 'dart:math' as math;
import 'package:swol/other/functions/helper.dart';

//PROPER rep range: 1 - > 35
class ToWeight{
  //NOTE: some functions CAN FAIL but that's okay we always have back ups for those that do
  //at all weight ranges, the function that approximate the one failing the most
  //is the one to its right
  //BACKUP ORDER: brzycki, mcGlothinOrLander, almazan, epleyOrBaechle [non failing]
  static double fromRepAnd1Rm(double reps, double max, int predictionID){
    bool positiveWeight = (max > 0);
    bool repsInt = ((reps.toInt()).toDouble() == reps);
    if(positiveWeight && repsInt){
      switch(predictionID){
        case 0: return brzycki(reps, max); break;
        case 1: return mcGlothinOrLanders(reps, max); break;
        case 2: return almazan(reps, max); break;
        case 3: return epleyOrBaechle(reps, max); break;
        case 4: return oConner(reps, max); break;
        case 5: return wathan(reps, max); break;
        case 6: return mayhew(reps, max); break;
        default: return lombardi(reps, max); break;
      }
    }
    else return null;
  }

  //1 Brzycki Function
  //[m * (37- r)] / 36
  //same limits as To1RM
  static double brzycki(double reps, double max){
    if(Functions.brzyckiUsefull(reps)){
      double a = 37 - reps;
      double b = max * a;
      double c = b / 36;
      return c;
    }
    else return mcGlothinOrLanders(reps, max);
  }

  //2 McGlothin (or Landers) Function
  //[m * (101.3 - [2.67123 * r])] / 100
  //same limits as To1RM
  static double mcGlothinOrLanders(double reps, double max){
    if(Functions.mcGlothinOrLandersUsefull(reps)){
      double a = 2.67123 * reps;
      double b = 101.3 - a;
      double c = max * b;
      double d = c / 100;
      return d;
    }
    else return almazan(reps, max);
  }

  //3 Almazan Function *our own
  /*
  - (0.244879 * m * ln[
    (r + 4.99195)
    -------------
    109.3355
  ])
  ----------------------
  ln(2)
  */
  //same limits as To1RM
  static double almazan(double reps, double max){
    if(Functions.almazanUsefull(reps)){
      double a = reps + 4.99195;
      double b = a / 109.3355;
      double c = math.log(b);
      double d = 0.244879 * max * c;
      double e = d / math.log(2);
      return -e;
    } 
    else return epleyOrBaechle(reps, max);
  }

  //4 Epley (or Baechle) Function
  //(30 * m) / (30 + r)
  //NOTE: no positive limits
  static double epleyOrBaechle(double reps, double max){
    return _helperOne(reps, max, 30);
  }

  //5 O`Conner Function
  //(40 * m) / (40 + r)
  //NOTE: no positive limits
  static double oConner(double reps, double max){
    return _helperOne(reps, max, 40);
  }

  //6 Wathan Function
  /*
  m * (48.8 + 53.8 * e ^[
    -0.075 * r
  ])
  -----------------------
  100
  */
  static double wathan(double reps, double max){
   return _helperTwo(reps, max, 48.8, 53.8, 0.075);
  }

  //7 Mayhew Function
  /*
  m * (52.2 + 41.9 * e ^[
    -0.055 * r
  ])
  -----------------------
  100
  */
  static double mayhew(double reps, double max){
    return _helperTwo(reps, max, 52.2, 41.9, 0.055);
  }

  //8 Lombardi Function
  //m / [r^(0.1)]
  static double lombardi(double reps, double max){
    double a = math.pow(reps,0.1);
    double b = max / a;
    return b;
  }

  //-------------------------Helpers-------------------------

  static double _helperOne(double reps, double max, double constant){
    double a = constant * max;
    double b = constant + reps;
    double c = a / b;
    return c;
  }

  static double _helperTwo(
    double reps, 
    double max, 
    double const1,
    double const2,
    double const3,
  ){
    double a = -const3 * reps;
    double b = math.pow(math.e, a);
    //max * (c1 + c2 * b)
    double c = const2 * b;
    double d = const1 + c;
    double e = max * d;
    return e / 100;
  }
}