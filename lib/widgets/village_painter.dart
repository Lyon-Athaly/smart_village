import 'package:flutter/material.dart';

class VillagePainter extends CustomPainter {
  const VillagePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final sky = Paint()..color = const Color(0xFFE2F6FF);

    canvas.drawRect(Offset.zero & size, sky);

    final hill = Paint()..color = const Color(0xFF9ED7B5);

    final ground = Paint()..color = const Color(0xFF72BF88);

    final hillPath = Path()
      ..moveTo(0, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.12,
        size.width * 0.5,
        size.height * 0.55,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.20,
        size.width,
        size.height * 0.55,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(hillPath, hill);

    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.65, size.width, size.height * 0.35),
      ground,
    );

    final road = Paint()..color = const Color(0xFFCBD6DE);

    final roadPath = Path()
      ..moveTo(size.width * 0.42, size.height)
      ..lineTo(size.width * 0.55, size.height * 0.62)
      ..lineTo(size.width * 0.70, size.height * 0.62)
      ..lineTo(size.width * 0.65, size.height)
      ..close();

    canvas.drawPath(roadPath, road);

    _drawBuilding(
      canvas,
      Offset(size.width * 0.58, size.height * 0.48),
      size.width * 0.25,
      size.height * 0.25,
    );

    _drawBuilding(
      canvas,
      Offset(size.width * 0.13, size.height * 0.70),
      size.width * 0.17,
      size.height * 0.15,
    );
  }

  void _drawBuilding(
    Canvas canvas,
    Offset offset,
    double width,
    double height,
  ) {
    final wall = Paint()..color = Colors.white;
    final roof = Paint()..color = const Color(0xFF2485C7);

    canvas.drawRect(Rect.fromLTWH(offset.dx, offset.dy, width, height), wall);

    final roofPath = Path()
      ..moveTo(offset.dx - 5, offset.dy)
      ..lineTo(offset.dx + width / 2, offset.dy - height * 0.25)
      ..lineTo(offset.dx + width + 5, offset.dy)
      ..close();

    canvas.drawPath(roofPath, roof);

    final window = Paint()..color = const Color(0xFF8CD7F5);

    for (int i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          offset.dx + width * (0.12 + i * 0.28),
          offset.dy + height * 0.25,
          width * 0.15,
          height * 0.22,
        ),
        window,
      );
    }

    final cross = Paint()
      ..color = const Color(0xFFE94C69)
      ..strokeWidth = 4;

    canvas.drawLine(
      Offset(offset.dx + width / 2, offset.dy + height * 0.5),
      Offset(offset.dx + width / 2, offset.dy + height * 0.8),
      cross,
    );

    canvas.drawLine(
      Offset(offset.dx + width * 0.35, offset.dy + height * 0.65),
      Offset(offset.dx + width * 0.65, offset.dy + height * 0.65),
      cross,
    );
  }

  @override
  bool shouldRepaint(covariant VillagePainter oldDelegate) {
    return false;
  }
}
