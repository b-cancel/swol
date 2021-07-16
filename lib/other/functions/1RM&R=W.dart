import 'dart:math' as math;
import 'package:swol/other/functions/helper.dart';

//PROPER rep range: 1 - > 35
class ToWeight {
  //NOTE: some functions CAN FAIL but that's okay we always have back ups for those that do
  //at all weight ranges, the function that approximate the one failing the most
  //is the one to its right
  //BACKUP ORDER: brzycki, mcGlothinOrLander, almazan, epleyOrBaechle [non failing]
  static double fromRepAnd1Rm(int reps, double max, int predictionID) {
    if (max > 0 && reps > 0) {
      switch (predictionID) {
        case 0:
          return brzycki(reps, max);
        case 1:
          return mcGlothinOrLanders(reps, max);
        case 2:
          return almazan(reps, max);
        case 3:
          return epleyOrBaechle(reps, max);
        case 4:
          return oConner(reps, max);
        case 5:
          return wathan(reps, max);
        case 6:
          return mayhew(reps, max);
        default:
          return lombardi(reps, max);
      }
    } else {
      return 0;
    }
  }

  //1 Brzycki Function
  //[m * (37- r)] / 36
  //same limits as To1RM
  static double brzycki(int reps, double max) {
    if (Functions.brzyckiUsefull(reps)) {
      double a = 37.0 - reps;
      double b = max * a;
      double c = b / 36;
      return c;
    } else
      return mcGlothinOrLanders(reps, max);
  }

  //2 McGlothin (or Landers) Function
  //[m * (101.3 - [2.67123 * r])] / 100
  //same limits as To1RM
  static double mcGlothinOrLanders(int reps, double max) {
    if (Functions.mcGlothinOrLandersUsefull(reps)) {
      double a = 2.67123 * reps;
      double b = 101.3 - a;
      double c = max * b;
      double d = c / 100;
      return d;
    } else
      return almazan(reps, max);
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
  static double almazan(int reps, double max) {
    if (Functions.almazanUsefull(reps)) {
      double a = reps + 4.99195;
      double b = a / 109.3355;
      double c = math.log(b);
      double d = 0.244879 * max * c;
      double e = d / math.log(2);
      return -e;
    } else
      return epleyOrBaechle(reps, max);
  }

  //4 Epley (or Baechle) Function
  //(30 * m) / (30 + r)
  //NOTE: no positive limits
  static double epleyOrBaechle(int reps, double max) {
    return _helperOne(reps, max, 30);
  }

  //5 O`Conner Function
  //(40 * m) / (40 + r)
  //NOTE: no positive limits
  static double oConner(int reps, double max) {
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
  static double wathan(int reps, double max) {
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
  static double mayhew(int reps, double max) {
    return _helperTwo(reps, max, 52.2, 41.9, 0.055);
  }

  //8 Lombardi Function
  //m / [r^(0.1)]
  static double lombardi(int reps, double max) {
    num a = math.pow(reps, 0.1);
    double b = max / a;
    return b;
  }

  //-------------------------Helpers-------------------------

  static double _helperOne(int reps, double max, double constant) {
    double a = constant * max;
    double b = constant + reps;
    double c = a / b;
    return c;
  }

  static double _helperTwo(
    int reps,
    double max,
    double const1,
    double const2,
    double const3,
  ) {
    double a = -const3 * reps;
    num b = math.pow(math.e, a);
    //max * (c1 + c2 * b)
    double c = const2 * b;
    double d = const1 + c;
    double e = max * d;
    return e / 100;
  }
}
