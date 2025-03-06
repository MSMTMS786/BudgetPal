
// Custom painter for the dollar bill part of the logo
import 'package:flutter/material.dart';

class DollarBillPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Path path = Path();
    // Create a stylized dollar bill shape
    path.moveTo(0, size.height * 0.3);
    path.lineTo(size.width * 0.7, 0);
    path.lineTo(size.width, size.height * 0.3);
    path.lineTo(size.width * 0.3, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Add dollar sign
    final TextPainter textPainter = TextPainter(
      text: const TextSpan(
        text: '\$',
        style: TextStyle(
          color: Color(0xFFFF5722), // Orange
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.width * 0.38 - textPainter.width / 2, 
             size.height * 0.45 - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}



class CustomColors{
  LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3F0D49), // Purple at top
              Color(0xFF1A1A2E), // Dark blue at bottom
    ],
  );
}