import 'package:flutter/material.dart';

// Seluruh ilustrasi digambar lokal. Tidak membutuhkan aset, API key, atau internet.
class VillagePainter extends CustomPainter {
  const VillagePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.scale(size.width / 400, size.height / 170);
    final paint = Paint();
    void rect(double x, double y, double w, double h, Color color) {
      canvas.drawRect(Rect.fromLTWH(x, y, w, h), paint..color = color);
    }
    void tree(double x, double y, double scale) {
      rect(x - 2, y, 4, 24 * scale, const Color(0xFF99704C));
      canvas.drawCircle(Offset(x, y), 14 * scale, paint..color = const Color(0xFF389A62));
      canvas.drawCircle(Offset(x - 8 * scale, y + 6 * scale), 10 * scale, paint..color = const Color(0xFF6ABD61));
    }
    final mountain = Path()..moveTo(0, 65)..quadraticBezierTo(55, 5, 110, 61)
      ..quadraticBezierTo(165, 5, 230, 67)..quadraticBezierTo(320, -2, 400, 59)
      ..lineTo(400, 170)..lineTo(0, 170)..close();
    canvas.drawPath(mountain, paint..color = const Color(0xFF91D3D5));
    final field = Path()..moveTo(0, 92)..quadraticBezierTo(105, 48, 215, 99)
      ..quadraticBezierTo(305, 56, 400, 93)..lineTo(400, 170)..lineTo(0, 170)..close();
    canvas.drawPath(field, paint..color = const Color(0xFF9CD688));
    final road = Path()..moveTo(160, 170)..cubicTo(200, 148, 310, 143, 218, 113)
      ..lineTo(233, 109)..cubicTo(345, 145, 247, 158, 241, 170)..close();
    canvas.drawPath(road, paint..color = const Color(0xFF93A4AD));
    for (final x in [54.0, 118.0, 187.0]) {
      rect(x, 83, 40, 34, Colors.white);
      final roof = Path()..moveTo(x - 6, 84)..lineTo(x + 20, 65)..lineTo(x + 46, 84)..close();
      canvas.drawPath(roof, paint..color = const Color(0xFFDB795C));
      rect(x + 7, 91, 9, 11, const Color(0xFF62B6DE));
      rect(x + 24, 94, 10, 23, const Color(0xFFB88E66));
    }
    rect(279, 64, 90, 63, Colors.white);
    rect(305, 43, 37, 84, const Color(0xFFF5FAFC));
    rect(320, 49, 7, 22, const Color(0xFFEF5964));
    rect(313, 56, 21, 7, const Color(0xFFEF5964));
    for (final x in [286.0, 299.0, 348.0, 361.0]) {
      for (final y in [77.0, 96.0]) {
        rect(x, y, 7, 12, const Color(0xFF69BAE0));
      }
    }
    rect(312, 100, 24, 27, const Color(0xFF388FBD));
    for (final point in [const Offset(22, 103), const Offset(44, 130),
      const Offset(255, 110), const Offset(386, 105), const Offset(348, 145)]) {
      tree(point.dx, point.dy, 0.9);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant VillagePainter oldDelegate) => false;
}

class HospitalPainter extends CustomPainter {
  final Color accent;
  final String? label;
  const HospitalPainter({required this.accent, this.label});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    final w = size.width;
    final h = size.height;
    final paint = Paint();
    void rect(double x, double y, double width, double height, Color color) {
      canvas.drawRect(Rect.fromLTWH(x * w, y * h, width * w, height * h), paint..color = color);
    }
    rect(0, 0, 1, 1, const Color(0xFFCCEAFE));
    canvas.drawOval(Rect.fromLTWH(w * .05, h * .12, w * .25, h * .09), paint..color = Colors.white);
    canvas.drawOval(Rect.fromLTWH(w * .68, h * .08, w * .26, h * .08), paint..color = Colors.white);
    rect(0, .73, 1, .27, const Color(0xFFACD594));
    rect(0, .90, 1, .10, const Color(0xFFB1BEC2));
    rect(.08, .34, .84, .47, const Color(0xFFE5EDF0));
    rect(.34, .22, .32, .62, Colors.white);
    rect(.07, .32, .27, .035, accent);
    rect(.66, .32, .27, .035, accent);
    for (final x in [.11, .20, .72, .81]) {
      for (final y in [.40, .55, .70]) {
        rect(x, y, .06, .085, const Color(0xFF7DB8CE));
        rect(x, y, .06, .012, Colors.white);
      }
    }
    rect(.482, .27, .036, .13, const Color(0xFFEE5966));
    rect(.443, .315, .114, .04, const Color(0xFFEE5966));
    rect(.405, .60, .19, .24, accent);
    rect(.496, .60, .008, .24, Colors.white);
    rect(.38, .565, .24, .035, const Color(0xFFCBD7DF));
    if (label != null) {
      final text = TextPainter(
        text: TextSpan(text: label!.toUpperCase(), style: TextStyle(
          fontSize: (w * .026).clamp(6.0, 13.0).toDouble(),
          fontWeight: FontWeight.w700, color: const Color(0xFF28445C),
        )),
        textAlign: TextAlign.center,
        maxLines: 2,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: w * .30);
      text.paint(canvas, Offset((w - text.width) / 2, h * .43));
    }
    for (final x in [.045, .955]) {
      rect(x - .007, .70, .014, .20, const Color(0xFF8F7851));
      canvas.drawOval(Rect.fromCenter(center: Offset(w * x, h * .68), width: w * .14, height: h * .27),
          paint..color = const Color(0xFF57A16A));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant HospitalPainter oldDelegate) =>
      oldDelegate.accent != accent || oldDelegate.label != label;
}

class MapPainter extends CustomPainter {
  const MapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    final w = size.width;
    final h = size.height;
    final paint = Paint();
    canvas.drawRect(Offset.zero & size, paint..color = const Color(0xFFEEF1E9));
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 6; col++) {
        final block = Rect.fromLTWH(col * w / 6 + 7, row * h / 9 + 7, w / 6 - 14, h / 9 - 14);
        canvas.drawRRect(RRect.fromRectAndRadius(block, const Radius.circular(5)),
            paint..color = (row + col) % 4 == 0 ? const Color(0xFFCCE7BC) : const Color(0xFFE1E6DA));
      }
    }
    final river = Path()..moveTo(w * .96, -20)
      ..cubicTo(w * .64, h * .20, w * .99, h * .40, w * .63, h * .52)
      ..cubicTo(w * .43, h * .65, w * .68, h * .78, w * .46, h + 20);
    canvas.drawPath(river, Paint()..color = const Color(0xFFB4DEED)
      ..style = PaintingStyle.stroke..strokeWidth = 18);
    final roads = <Path>[
      Path()..moveTo(-20, h * .13)..lineTo(w + 20, h * .72),
      Path()..moveTo(-20, h * .79)..lineTo(w * .88, -20),
      Path()..moveTo(w * .19, -20)..lineTo(w * .53, h + 20),
      Path()..moveTo(-20, h * .48)..lineTo(w + 20, h * .36),
      Path()..moveTo(-20, h * .97)..lineTo(w + 20, h * .62),
    ];
    for (final path in roads) {
      canvas.drawPath(path, Paint()..color = const Color(0xFFD8DDCF)
        ..style = PaintingStyle.stroke..strokeWidth = 13);
      canvas.drawPath(path, Paint()..color = Colors.white
        ..style = PaintingStyle.stroke..strokeWidth = 9);
    }
    final mainRoad = Path()..moveTo(w * .50, -20)..lineTo(w * .67, h * .38)..lineTo(w + 20, h * .76);
    canvas.drawPath(mainRoad, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 13);
    canvas.drawPath(mainRoad, Paint()..color = const Color(0xFFF5D991)..style = PaintingStyle.stroke..strokeWidth = 7);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MapPainter oldDelegate) => false;
}
