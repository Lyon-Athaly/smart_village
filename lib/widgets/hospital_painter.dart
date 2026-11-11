import 'dart:math' as math;

import 'package:flutter/material.dart';

class HospitalPainter extends CustomPainter {
  final Color accent;

  const HospitalPainter({this.accent = const Color(0xFF0875E1)});

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFFE4F4FF);

    canvas.drawRect(Offset.zero & size, background);

    final wall = Paint()..color = Colors.white;

    final roof = Paint()..color = accent;

    final window = Paint()..color = const Color(0xFF91D2EE);

    final left = size.width * 0.12;
    final top = size.height * 0.28;
    final width = size.width * 0.76;
    final height = size.height * 0.55;

    canvas.drawRect(Rect.fromLTWH(left, top, width, height), wall);

    canvas.drawRect(Rect.fromLTWH(left - 5, top - 6, width + 10, 9), roof);

    for (int row = 0; row < 2; row++) {
      for (int col = 0; col < 4; col++) {
        canvas.drawRect(
          Rect.fromLTWH(
            left + width * (0.09 + col * 0.22),
            top + height * (0.20 + row * 0.30),
            width * 0.13,
            height * 0.15,
          ),
          window,
        );
      }
    }

    final cross = Paint()
      ..color = const Color(0xFFE94C69)
      ..strokeWidth = math.max(2, size.width * 0.025);

    canvas.drawLine(
      Offset(size.width * 0.5, top - 2),
      Offset(size.width * 0.5, top - size.height * 0.13),
      cross,
    );

    canvas.drawLine(
      Offset(size.width * 0.44, top - size.height * 0.07),
      Offset(size.width * 0.56, top - size.height * 0.07),
      cross,
    );
  }

  @override
  bool shouldRepaint(covariant HospitalPainter oldDelegate) {
    return oldDelegate.accent != accent;
  }
}
