import 'package:flutter/material.dart';

class TriangleUp extends StatelessWidget {
  const TriangleUp({
    Key? key,
    this.widthDivisor: 1,
  }) : super(key: key);

  final int widthDivisor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrianglePainter(),
      child: Container(
        width: MediaQuery.of(context).size.width / widthDivisor,
        height: 24,
      ),
    );
  }
}

class TriangleDown extends StatelessWidget {
  const TriangleDown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrianglePainter(
        faceDown: true,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 24,
      ),
    );
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
    if (faceDown) {
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(0, 0);
    } else {
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(0, size.height);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
