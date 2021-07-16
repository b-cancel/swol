import 'dart:math' as math;

//PROPER weight range: 1 - > ???
class ToReps {
  static double from1RMandWeight(double max, double weight, int predictionID) {
    if (max > 0 && weight > 0) {
      switch (predictionID) {
        case 0:
          return brzycki(weight, max);
        case 1:
          return mcGlothinOrLanders(weight, max);
        case 2:
          return almazan(weight, max);
        case 3:
          return epleyOrBaechle(weight, max);
        case 4:
          return oConner(weight, max);
        case 5:
          return wathan(weight, max);
        case 6:
          return mayhew(weight, max);
        default:
          return lombardi(weight, max);
      }
    } else {
      return 0;
    }
  }

  //1 Brzycki Function
  //-36*w - 37*m
  //-------------
  //      m
  static double brzycki(double weight, double max) {
    double a = 36 * weight;
    double b = -37 * max;
    double c = a + b;
    if (c == 0)
      return 0;
    else
      return -(c / max);
  }

  //2 McGlothin (or Landers) Function
  //-[(100*w) / m] - 101.3
  //-----------------------
  //        2.67123
  static double mcGlothinOrLanders(double weight, double max) {
    double a = 100 * weight;
    double b = a / max;
    double c = b - 101.3;
    if (c == 0)
      return 0;
    else
      return -(c / 2.67123);
  }

  //3 Almazan Function *our own
  /*e ^ ( NEGATIVE
    [ln(2)*w]
  ----------------
    [0.244879*m]
  )
  */
  //TIMES 109.3355 - 4.99195
  static double almazan(double weight, double max) {
    double a = math.log(2) * weight; //[ln(2)*w]
    double b = 0.244879 * max; //[0.244879*m]
    double c = -(a / b);
    num d = math.pow(math.e, c);
    double e = d * 109.3355;
    return e - 4.99195;
  }

  //4 Epley (or Baechle) Function
  static double epleyOrBaechle(double weight, double max) {
    return _helperOne(weight, max, 30);
  }

  //5 O`Conner Function
  static double oConner(double weight, double max) {
    return _helperOne(weight, max, 40);
  }

  //6 Wathan Function
  static double wathan(double weight, double max) {
    return _helperTwo(weight, max, 48.8, 53.8, 0.075);
  }

  //7 Mayhew Function
  static double mayhew(double weight, double max) {
    return _helperTwo(weight, max, 52.2, 41.9, 0.055);
  }

  //8 Lombardi Function
  //m^10 / w^10
  static double lombardi(double weight, double max) {
    return math.pow(max, 10) / math.pow(weight, 10);
  }

  //-------------------------Helpers-------------------------

  //[(const*m) / w] - const
  static double _helperOne(double weight, double max, double constant) {
    double a = constant * max;
    double b = a / weight;
    return b - constant;
  }

  /*-ln(
    [(100*w / m) - const1] 
    --------------------
            const2
  )
  -----------------------
            const3
  */
  static double _helperTwo(
    double weight,
    double max,
    double const1,
    double const2,
    double const3,
  ) {
    double a = 100 * weight;
    double b = a / max;
    double c = b - const1;
    if (c == 0)
      return 0;
    else {
      double d = c / const2;
      if (d < 0)
        return 0;
      else {
        double e = math.log(d);
        if (e == 0)
          return 0;
        else {
          double f = e / const3;
          return -f;
        }
      }
    }
  }
}
