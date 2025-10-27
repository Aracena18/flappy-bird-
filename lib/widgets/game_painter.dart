import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/bird.dart';
import '../models/map_data.dart';
import '../models/pipe.dart';

class GamePainter extends CustomPainter {
  final Bird bird;
  final List<Pipe> pipes;
  final MapData mapData;

  GamePainter({
    required this.bird,
    required this.pipes,
    required this.mapData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw stars for space and moon maps
    if (mapData.name == 'Space' || mapData.name == 'Moon') {
      _drawStars(canvas, size);
    }

    // Draw pipes
    final pipePaint = Paint()
      ..color = mapData.pipeColor
      ..style = PaintingStyle.fill;

    final pipeOutlinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var pipe in pipes) {
      // Top pipe
      final topRect = pipe.getTopRect(size.height);
      canvas.drawRect(topRect, pipePaint);
      canvas.drawRect(topRect, pipeOutlinePaint);
      
      // Draw pipe cap
      final topCapRect = Rect.fromLTWH(
        topRect.left - 5,
        topRect.bottom - 30,
        topRect.width + 10,
        30,
      );
      canvas.drawRect(topCapRect, pipePaint);
      canvas.drawRect(topCapRect, pipeOutlinePaint);

      // Bottom pipe
      final bottomRect = pipe.getBottomRect(size.height);
      canvas.drawRect(bottomRect, pipePaint);
      canvas.drawRect(bottomRect, pipeOutlinePaint);
      
      // Draw pipe cap
      final bottomCapRect = Rect.fromLTWH(
        bottomRect.left - 5,
        bottomRect.top,
        bottomRect.width + 10,
        30,
      );
      canvas.drawRect(bottomCapRect, pipePaint);
      canvas.drawRect(bottomCapRect, pipeOutlinePaint);
    }

    // Draw bird
    _drawBird(canvas, size);
  }

  void _drawStars(Canvas canvas, Size size) {
    final starPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent stars
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 1;
      canvas.drawCircle(Offset(x, y), radius, starPaint);
    }
  }

  void _drawBird(Canvas canvas, Size size) {
    final birdRect = bird.getRect();
    final center = Offset(birdRect.center.dx, birdRect.center.dy);
    final radius = birdRect.width / 2;

    // Shadow for depth
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center.translate(2, 3), radius, shadowPaint);
    
    // Bird body with gradient
    final bodyGradient = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.yellow.shade300,
          Colors.yellow.shade700,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyGradient);

    // Body outline
    final bodyOutlinePaint = Paint()
      ..color = Colors.orange.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(center, radius, bodyOutlinePaint);

    // Wing with animation
    final wingPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.orange.shade600, Colors.orange.shade800],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final wingAngle = (bird.velocity / 10) * math.pi / 4;
    final wingPath = Path();
    wingPath.moveTo(center.dx, center.dy);
    wingPath.lineTo(
      center.dx - radius * 0.8,
      center.dy + radius * 0.5 + math.sin(wingAngle) * 12,
    );
    wingPath.lineTo(center.dx - radius * 0.4, center.dy + radius * 0.8);
    wingPath.close();
    canvas.drawPath(wingPath, wingPaint);
    canvas.drawPath(wingPath, bodyOutlinePaint);

    // Eye white
    final eyeWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + radius * 0.3, center.dy - radius * 0.25),
      radius * 0.35,
      eyeWhitePaint,
    );

    // Pupil
    final pupilPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + radius * 0.4, center.dy - radius * 0.2),
      radius * 0.18,
      pupilPaint,
    );

    // Eye shine
    final shinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + radius * 0.45, center.dy - radius * 0.25),
      radius * 0.08,
      shinePaint,
    );

    // Beak
    final beakPaint = Paint()
      ..color = Colors.orange.shade700
      ..style = PaintingStyle.fill;

    final beakPath = Path();
    beakPath.moveTo(center.dx + radius * 0.7, center.dy - 3);
    beakPath.lineTo(center.dx + radius * 1.4, center.dy);
    beakPath.lineTo(center.dx + radius * 0.7, center.dy + 3);
    beakPath.close();
    canvas.drawPath(beakPath, beakPaint);
    
    final beakOutline = Paint()
      ..color = Colors.orange.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(beakPath, beakOutline);
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) {
    return true; // Always repaint for animation
  }
}
