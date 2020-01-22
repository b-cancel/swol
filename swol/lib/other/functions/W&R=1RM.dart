import 'dart:math' as math;

class To1RM{
  //NOTE: some functions CAN FAIL but that's okay we always have back ups for those that do
  //at all weight ranges, the function that approximate the one failing the most
  //is the one to its right
  //BACKUP ORDER: brzycki, mcGlothinOrLander, almazan, epleyOrBaechle [non failing]
  static double fromWeightAndReps(double weight, double reps, int predictionID){
    bool positiveWeight = (weight > 0);
    bool repsInt = ((reps.toInt()).toDouble() == reps);
    if(positiveWeight && repsInt){
      switch(predictionID){
        case 0: return brzycki(weight, reps); break;
        case 1: return mcGlothinOrLanders(weight, reps); break;
        case 2: return almazan(weight, reps); break;
        case 3: return epleyOrBaechle(weight, reps); break;
        case 4: return oConner(weight, reps); break;
        case 5: return wathan(weight, reps); break;
        case 6: return mayhew(weight, reps); break;
        default: return lombardi(weight, reps); break;
      }
    }
    else return null;
  }

  //1 Brzycki Function
  //w * (36 / [37 - r]) 
  //r: must not be 37 (for sure)
  //r: must not be anything above 37 (logically)
  static bool brzyckiUsefull(double reps) => (reps < 37);
  static double brzycki(double weight, double reps){
    if(brzyckiUsefull(reps)){
      double a = 37 - reps;
      double b = 36 / a;
      double c = weight * b;
      return c;
    }
    else return mcGlothinOrLanders(weight, reps);
  }

  //2 McGlothin (or Landers) Function
  /*
  (100 * w)
  ------------------------
  (101.3 - [2.67123 * r])
  */
  //r: must not be 37.9226049423 (technically)
  //r: must not be anything above 37.9226049423 (logically)
  //r: and logically you can assume the number is 38 
  //    1. because we are only ever going to be passed int reps
  //    2. and because 37 actually does work here whereas 38 does not
  static bool mcGlothinOrLandersUsefull(double reps) => (reps < 38);
  static double mcGlothinOrLanders(double weight, double reps){
    if(mcGlothinOrLandersUsefull(reps)){
      double a = 100 * weight;
      double b = 2.67123 * reps;
      double c = 101.3 - b;
      double d = a / c;
      return d;
    }
    else return almazan(weight, reps);
  }

  //3 Almazan Function
  /*
  (ln(2) * w)
  ---------------------
  (0.244879 * ln[
    (r + 4.99195) / 109.3355
  ])
  */ 
  //r: must not be 104.34355 (technically)
  //r: must not anything above 104.34355 (logically)
  //r: and logically youc an assume the number is 105
  //    1. because we are only ever going to be passed int reps
  //    2. and because 104 does work here whereas 105 does not
  static bool almazanUsefull(double reps) => (reps < 105);
  static double almazan(double weight, double reps){ 
    if(almazanUsefull(reps)){
      double a = math.log(2);
      double b = a * weight;
      //---
      double c = reps + 4.99195;
      double d = c / 109.3355;
      double e = math.log(d);
      double f = 0.244879 * e;
      //---
      double g = b / f;
      return -g;
    } 
    else return epleyOrBaechle(weight, reps);
  }

  //4 Epley (or Baechle) Function
  //w * (1 + [r / 30])

  static double epleyOrBaechle(double weight, double reps){
    return _helperOne(weight, reps, 30);
  }

  //5 O`Conner Function
  //w * (1 + [r / 40])

  static double oConner(double weight, double reps){
    return _helperOne(weight, reps, 40);
  }

  //6 Wathan Function (no limit although it seems like there would be)
  /*
  100 * w
  ------------------------
  48.8 + (53.8 * e ^[
    -0.075 * r
  ])
  */

  static double wathan(double weight, double reps){
    return _helperTwo(
      weight, 
      reps, 
      48.8, 
      53.8, 
      0.075,
    );
  }

  //7 Mayhew Function (no limit although it seems like there would be)
  /*
  100 * w
  ------------------------
  52.2 + (41.9 * e ^[
    -0.055 * r
  ])
  */

  static double mayhew(double weight, double reps){
    return _helperTwo(
      weight, 
      reps, 
      52.2, 
      41.9, 
      0.055,
    );
  }

  //8 Lombardi Function
  //w * (r ^ [0.10])

  static double lombardi(double weight, double reps){
    double a = math.pow(reps, 0.10);
    double b = weight * a;
    return b;
  } 

  //-------------------------Helpers-------------------------

  //w * (1 + [r / constant])
  static double _helperOne(double weight, double reps, double constant){
    double a = reps / constant;
    double b = 1 + a;
    double c = weight * b;
    return c;
  }

  /*
  100 * w
  ------------------------
  const1 + (const2 * e ^ [
    -const3 * r
  ])
  */
  static double _helperTwo(
    double weight, 
    double reps, 
    double const1,
    double const2,
    double const3,
  ){
    double a = 100 * weight;
    //---
    double b = -const3 * reps;
    double c = math.pow(math.e, b);
    double d = const2 * c;
    double e = const1 + d;
    //---
    double f = a / e;
    return f;
  }
}