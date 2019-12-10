import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vector;


class TriangleMath{
  //points constants
  static const List<double> topLeft       = [0,    0];
  static const List<double> topCenter     = [0.5,  0];
  static const List<double> topRight      = [1,    0];
  static const List<double> right         = [1,  0.5];
  static const List<double> bottomRight   = [1,    1];
  static const List<double> bottomCenter  = [0.5,  1];
  static const List<double> bottomLeft    = [0,    1];
  static const List<double> left          = [0,  0.5];

  //check vague point locations
  static bool isTopEdge(List<double> point) => (point[1] == 0);
  static bool isRightEdge(List<double> point) => (point[0] == 1);
  static bool isBottomEdge(List<double> point) => (point[1] == 1);
  static bool isLeftEdge(List<double> point) => (point[0] == 0);

  static double specialTan(double theta){
    return 0.5 * math.tan(vector.radians(theta));
  }

  //clockwise (from corner)
  //NOTE: we don't need to handle corners 
  //becaue worst case scenario we have the same point twice
  static List<List<double>> toPoint(List<double> point, bool bothBefore){
    if(isTopEdge(point)){
      if(bothBefore) return [topRight, bottomRight, bottomLeft, topLeft];
      else return [];
    } //add to end
    else if(isRightEdge(point)) return [topRight];
    else if(isBottomEdge(point)) return [topRight, bottomRight];
    else return [topRight, bottomRight, bottomLeft];
  }

  //counter clockwise (to corner)
  //NOTE: we don't need to handle corners 
  //becaue worst case scenario we have the same point twice
  static List<List<double>> fromPoint(List<double> point){
    if(isTopEdge(point)){
      if(point[0] < 0.5) return [topLeft, bottomLeft, bottomRight, topRight];
      else return [];
    } //add to start
    else if(isRightEdge(point)) return [topRight];
    else if(isBottomEdge(point)) return [bottomRight, topRight];
    else return [bottomLeft, bottomRight, topRight];
  }

  //exactly what it says it does
  static List<double> angleToPoint(double angle){
    //determine if its one of the 8 solid points
    if((angle.toInt().toDouble() == angle)){
      int intAngle = angle.toInt();
      switch(intAngle){
        case 0:   return topCenter;
        case 45:  return topRight;
        case 90:  return right;
        case 135: return bottomRight;
        case 180: return bottomCenter;
        case 225: return bottomLeft;
        case 270: return left;
        case 315: return topLeft;
        default: break;
      }
    }

    //make sure angle is less than 360
    if(angle >= 360) angle = angle % 360;

    //if we haven't returned by now then we are not one of the 8
    List<double> xy = [0,0];

    //set the one dimmension we know
    if(315 < angle || angle < 45) xy[1] = 0; //set y to 0
    else if(angle < 135) xy[0] = 1; //set x to 1
    else if(angle < 225) xy[1] = 1; //set y to 1
    else xy[0] = 0; //set x to 0

    //set the dimension we don't know
    if(angle > 315){
      double theta = -angle + 360;
      double result = specialTan(theta);
      xy[0] = -result + 0.5;
    }
    else if(angle > 270){
      double theta = angle - 270;
      double result = specialTan(theta);
      xy[1] = -result + 0.5;
    }
    else if(angle > 225){
      double theta = -angle + 270;
      double result = specialTan(theta);
      xy[1] = result + 0.5;
    }
    else if(angle > 180){
      double theta = angle - 180;
      double result = specialTan(theta);
      xy[0] = -result + 0.5;
    }
    else if(angle > 135){ 
      double theta = -angle + 180;
      double result = specialTan(theta);
      xy[0] = result + 0.5;
    }
    else if(angle > 90){
      double theta = angle - 90;
      double result = specialTan(theta);
      xy[1] = result + 0.5;
    }
    else if(angle> 45){
      double theta = -angle + 90;
      double result = specialTan(theta);
      xy[1] = -result + 0.5;
    }
    else{
      double theta = angle;
      double result = specialTan(theta);
      xy[0] = result + 0.5;
    }

    //return the results
    return xy;
  }
}

class TriangleAngle extends StatelessWidget {
  const TriangleAngle({
    @required this.size,
    @required this.start,
    @required this.end,
    this.color: Colors.white,
    Key key,
  }) : super(key: key);

  final double size;
  final double start;
  final double end;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrianglePainter(
        start: start,
        end: end,
        color: color,
      ),
      child: Container(
        width: size,
        height: size,
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  TrianglePainter({
    @required this.start,
    @required this.end,
    @required this.color,
  });

  final double start;
  final double end;
  final Color color;

  static const List<double> corner = [0, 0];
  static const List<double> center = [0.5, 0.5];

  @override
  void paint(Canvas canvas, Size size) {
    List<List<double>> points = new List<List<double>>();

    //calculate our detail points
    List<double> startPoint = TriangleMath.angleToPoint(start);
    List<double> endPoint = TriangleMath.angleToPoint(end);

    //add in all the points
    points.add(corner);
    points.addAll(TriangleMath.toPoint(
      startPoint, 
      startPoint[0] < 0.5 && endPoint[0] < 0.5,
    ));
    points.add(startPoint);
    points.add(center);
    points.add(endPoint);
    points.addAll(TriangleMath.fromPoint(endPoint),);
    points.add(corner);

    //setup for drawing shape
    final paint = Paint();
    paint.color = color;
    var path = Path();

    //iterate through all the points
    for(int i = 0; i < points.length; i++){
      List<double> point = points[i];
      //and add them to the path
      path.lineTo(
        point[0] * size.width, 
        point[1] * size.height,
      );
    }

    //close shape
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}