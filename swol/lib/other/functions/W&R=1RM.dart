import 'dart:math' as math;
import 'package:swol/other/functions/helper.dart';

//PROPER weight range 1 -> ?
class To1RM {
  //NOTE: some functions CAN FAIL but that's okay we always have back ups for those that do
  //at all weight ranges, the function that approximate the one failing the most
  //is the one to its right
  //BACKUP ORDER: brzycki, mcGlothinOrLander, almazan, epleyOrBaechle [non failing]
  static double? fromWeightAndReps(double weight, int reps, int predictionID) {
    bool positiveWeight = (weight > 0);
    if (positiveWeight) {
      switch (predictionID) {
        case 0:
          return brzycki(weight, reps);
        case 1:
          return mcGlothinOrLanders(weight, reps);
        case 2:
          return almazan(weight, reps);
        case 3:
          return epleyOrBaechle(weight, reps);
        case 4:
          return oConner(weight, reps);
        case 5:
          return wathan(weight, reps);
        case 6:
          return mayhew(weight, reps);
        default:
          return lombardi(weight, reps);
      }
    } else
      return null;
  }

  //1 Brzycki Function
  //w * (36 / [37 - r])
  static double brzycki(double weight, int reps) {
    if (Functions.brzyckiUsefull(reps)) {
      double a = 37.0 - reps;
      double b = 36 / a;
      double c = weight * b;
      return c;
    } else
      return mcGlothinOrLanders(weight, reps);
  }

  //2 McGlothin (or Landers) Function
  /*
  (100 * w)
  ------------------------
  (101.3 - [2.67123 * r])
  */
  static double mcGlothinOrLanders(double weight, int reps) {
    if (Functions.mcGlothinOrLandersUsefull(reps)) {
      double a = 100 * weight;
      double b = 2.67123 * reps;
      double c = 101.3 - b;
      double d = a / c;
      return d;
    } else
      return almazan(weight, reps);
  }

  //3 Almazan Function
  /*
  (ln(2) * w)
  ---------------------
  (0.244879 * ln[
    (r + 4.99195) / 109.3355
  ])
  */
  static double almazan(double weight, int reps) {
    if (Functions.almazanUsefull(reps)) {
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
    } else
      return epleyOrBaechle(weight, reps);
  }

  //4 Epley (or Baechle) Function
  //w * (1 + [r / 30])
  static double epleyOrBaechle(double weight, int reps) {
    return _helperOne(weight, reps, 30);
  }

  //5 O`Conner Function
  //w * (1 + [r / 40])
  static double oConner(double weight, int reps) {
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
  static double wathan(double weight, int reps) {
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
  static double mayhew(double weight, int reps) {
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
  static double lombardi(double weight, int reps) {
    num a = math.pow(reps, 0.10);
    double b = weight * a;
    return b;
  }

  //-------------------------Helpers-------------------------

  //w * (1 + [r / constant])
  static double _helperOne(double weight, int reps, double constant) {
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
    int reps,
    double const1,
    double const2,
    double const3,
  ) {
    double a = 100 * weight;
    //---
    double b = -const3 * reps;
    num c = math.pow(math.e, b);
    double d = const2 * c;
    double e = const1 + d;
    //---
    double f = a / e;
    return f;
  }
}
