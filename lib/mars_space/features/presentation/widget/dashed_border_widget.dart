import 'package:flutter/material.dart';

class DashedBorder extends StatelessWidget {
  final double strokeWidth;
  final Color color;
  final double gapWidth;
  final double borderRadius;
  final Widget child;

  DashedBorder({
    this.strokeWidth = 1.0,
    this.color = Colors.black,
    this.gapWidth = 5.0,
    this.borderRadius = 0.0,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.transparent, // Transparent color to avoid visible solid border
            width: strokeWidth,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: CustomPaint(
          painter: DashedPainter(color: color, strokeWidth: strokeWidth, gapWidth: gapWidth),
          child: child,
        ),
      ),
    );
  }
}

class DashedPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gapWidth;

  DashedPainter({
    required this.color,
    required this.strokeWidth,
    required this.gapWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double dashWidth = 10;
    final double dashSpace = gapWidth;

    // Top border
    double startX = dashWidth / 2;
    while (startX < size.width - dashWidth / 2) {
      canvas.drawLine(
          Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }

    // Right border
    double startY = 0; // Start from the top
    while (startY < size.height - dashWidth / 2) {
      canvas.drawLine(
          Offset(size.width, startY), Offset(size.width, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }

    // Bottom border
    double endX = size.width - dashWidth / 2;
    while (endX > dashWidth / 2) {
      canvas.drawLine(
          Offset(endX, size.height), Offset(endX - dashWidth, size.height), paint);
      endX -= dashWidth + dashSpace;
    }

    // Left border
    double endY = size.height;
    while (endY > dashWidth / 2) {
      canvas.drawLine(
          Offset(0, endY), Offset(0, endY - dashWidth), paint);
      endY -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}