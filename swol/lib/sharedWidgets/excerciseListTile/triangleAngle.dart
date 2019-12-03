import 'package:flutter/material.dart';

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

  @override
  void paint(Canvas canvas, Size size) {
    //setup for drawing shape
    final paint = Paint();
    paint.color = color;
    var path = Path();

    //setup the first point
    
    /*
    if(faceDown){
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width/2, size.height);
      path.lineTo(0, 0);
    }
    else{
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width/2, 0);
      path.lineTo(0, size.height);
    }
    */

    //draw the shape
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}