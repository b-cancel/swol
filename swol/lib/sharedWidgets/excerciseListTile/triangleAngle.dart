import 'package:flutter/material.dart';

class TriangleAngle extends StatelessWidget {
  const TriangleAngle({
    @required this.start,
    @required this.end,
    Key key,
  }) : super(key: key);

  final double start;
  final double end;

  @override
  Widget build(BuildContext context) {
    /*
    return CustomPaint(
      painter: TrianglePainter(
        faceDown: true,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 24,
      ),
    );
    */
    return Container();
  }
}

class TrianglePainter extends CustomPainter {
  TrianglePainter({
    this.faceDown: false,
  });

  final bool faceDown;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = Colors.black;

    var path = Path();
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
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}