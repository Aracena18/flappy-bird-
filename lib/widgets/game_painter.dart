import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/bird.dart';
import '../models/bird_customization.dart';
import '../models/map_data.dart';
import '../models/pipe.dart';

class GamePainter extends CustomPainter {
  final Bird bird;
  final List<Pipe> pipes;
  final MapData mapData;
  final BirdCustomization? birdCustomization;
  final bool isImmune;

  GamePainter({
    required this.bird,
    required this.pipes,
    required this.mapData,
    this.birdCustomization,
    this.isImmune = false,
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

    // Get customization colors and bird type
    final colorScheme = birdCustomization?.colorScheme ??
        BirdColorScheme(
          primary: Colors.yellow.shade300,
          secondary: Colors.yellow.shade700,
          name: 'Classic Yellow',
        );

    final birdType = birdCustomization?.birdIndex ?? 0;

    // Draw immunity shield glow if immune
    if (isImmune) {
      final glowPaint = Paint()
        ..color = Colors.cyan.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      
      canvas.drawCircle(center, radius + 15, glowPaint);
      
      // Additional pulsing effect
      final pulseRadius = radius + 20;
      final pulsePaint = Paint()
        ..color = Colors.cyan.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      
      canvas.drawCircle(center, pulseRadius, pulsePaint);
    }

    // Shadow for depth
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center.translate(3, 4), radius, shadowPaint);

    // Draw bird based on type
    switch (birdType) {
      case 0:
        _drawDefaultBird(canvas, center, radius, colorScheme);
        break;
      case 1:
        _drawIronBird(canvas, center, radius);
        break;
      case 2:
        _drawHulkBird(canvas, center, radius);
        break;
      case 3:
        _drawEagle(canvas, center, radius);
        break;
      case 4:
        _drawHawk(canvas, center, radius);
        break;
      case 5:
        _drawAaron(canvas, center, radius);
        break;
      case 6:
        _drawAngel(canvas, center, radius);
        break;
      case 7:
        _drawFilipino(canvas, center, radius);
        break;
    }
  }

  // Default Bird - Classic round bird with custom colors
  void _drawDefaultBird(Canvas canvas, Offset center, double radius,
      BirdColorScheme colorScheme) {
    // Bird body with gradient
    final bodyGradient = Paint()
      ..shader = RadialGradient(
        colors: [colorScheme.primary, colorScheme.secondary],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyGradient);

    // Body outline
    final bodyOutlinePaint = Paint()
      ..color = colorScheme.secondary.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(center, radius, bodyOutlinePaint);

    // Wing with animation
    final wingPaint = Paint()
      ..shader = LinearGradient(
        colors: [colorScheme.primary.withOpacity(0.8), colorScheme.secondary],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final wingAngle = (bird.velocity / 10) * math.pi / 4;
    final wingPath = Path();
    wingPath.moveTo(center.dx, center.dy);
    wingPath.lineTo(center.dx - radius * 0.8,
        center.dy + radius * 0.5 + math.sin(wingAngle) * 12);
    wingPath.lineTo(center.dx - radius * 0.4, center.dy + radius * 0.8);
    wingPath.close();
    canvas.drawPath(wingPath, wingPaint);
    canvas.drawPath(wingPath, bodyOutlinePaint);

    _drawStandardEye(canvas, center, radius);
    _drawStandardBeak(canvas, center, radius);
  }

  // Iron Bird - Mechanical/robotic appearance
  void _drawIronBird(Canvas canvas, Offset center, double radius) {
    // Metallic body with gradient
    final bodyGradient = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFB0BEC5),
          const Color(0xFF607D8B),
          const Color(0xFF455A64),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyGradient);

    // Metal panels outline
    final panelPaint = Paint()
      ..color = const Color(0xFF263238)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, panelPaint);
    canvas.drawCircle(center, radius * 0.6, panelPaint);

    // Mechanical wing
    final wingPaint = Paint()
      ..color = const Color(0xFF78909C)
      ..style = PaintingStyle.fill;

    final wingAngle = (bird.velocity / 10) * math.pi / 6;
    final wingPath = Path();
    wingPath.moveTo(center.dx - radius * 0.2, center.dy);
    wingPath.lineTo(center.dx - radius * 0.9,
        center.dy + radius * 0.3 + math.sin(wingAngle) * 10);
    wingPath.lineTo(center.dx - radius * 0.7, center.dy + radius * 0.6);
    wingPath.lineTo(center.dx - radius * 0.4, center.dy + radius * 0.5);
    wingPath.close();
    canvas.drawPath(wingPath, wingPaint);
    canvas.drawPath(wingPath, panelPaint);

    // Rivets
    final rivetPaint = Paint()
      ..color = const Color(0xFF37474F)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx - radius * 0.3, center.dy - radius * 0.3),
        2,
        rivetPaint);
    canvas.drawCircle(
        Offset(center.dx + radius * 0.3, center.dy + radius * 0.3),
        2,
        rivetPaint);

    // Glowing mechanical eye
    final eyeGlowPaint = Paint()
      ..color = const Color(0xFF00BCD4).withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(
        Offset(center.dx + radius * 0.35, center.dy - radius * 0.2),
        radius * 0.25,
        eyeGlowPaint);

    final eyePaint = Paint()
      ..color = const Color(0xFF00E5FF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx + radius * 0.35, center.dy - radius * 0.2),
        radius * 0.2,
        eyePaint);

    // Mechanical beak
    final beakPaint = Paint()
      ..color = const Color(0xFF546E7A)
      ..style = PaintingStyle.fill;
    final beakPath = Path();
    beakPath.moveTo(center.dx + radius * 0.7, center.dy - 4);
    beakPath.lineTo(center.dx + radius * 1.3, center.dy);
    beakPath.lineTo(center.dx + radius * 0.7, center.dy + 4);
    beakPath.close();
    canvas.drawPath(beakPath, beakPaint);
  }

  // Hulk Bird - Muscular and strong
  void _drawHulkBird(Canvas canvas, Offset center, double radius) {
    // Muscular green body
    final bodyGradient = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF66BB6A),
          const Color(0xFF388E3C),
          const Color(0xFF1B5E20),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyGradient);

    // Muscle definition lines
    final musclePaint = Paint()
      ..color = const Color(0xFF1B5E20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final musclePath = Path();
    musclePath.moveTo(center.dx, center.dy - radius * 0.5);
    musclePath.quadraticBezierTo(center.dx - radius * 0.3, center.dy,
        center.dx - radius * 0.2, center.dy + radius * 0.5);
    canvas.drawPath(musclePath, musclePaint);

    final musclePath2 = Path();
    musclePath2.moveTo(center.dx, center.dy - radius * 0.5);
    musclePath2.quadraticBezierTo(center.dx + radius * 0.3, center.dy,
        center.dx + radius * 0.2, center.dy + radius * 0.5);
    canvas.drawPath(musclePath2, musclePaint);

    // Strong wing
    final wingPaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFF66BB6A), const Color(0xFF2E7D32)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final wingAngle = (bird.velocity / 10) * math.pi / 4;
    final wingPath = Path();
    wingPath.moveTo(center.dx - radius * 0.1, center.dy - radius * 0.2);
    wingPath.lineTo(center.dx - radius * 0.9,
        center.dy + radius * 0.4 + math.sin(wingAngle) * 12);
    wingPath.lineTo(center.dx - radius * 0.5, center.dy + radius * 0.9);
    wingPath.lineTo(center.dx - radius * 0.2, center.dy + radius * 0.6);
    wingPath.close();
    canvas.drawPath(wingPath, wingPaint);
    canvas.drawPath(wingPath, musclePaint);

    // Angry eyes
    final eyeWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx + radius * 0.3, center.dy - radius * 0.25),
        radius * 0.3,
        eyeWhitePaint);

    final pupilPaint = Paint()
      ..color = const Color(0xFF1B5E20)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx + radius * 0.35, center.dy - radius * 0.2),
        radius * 0.15,
        pupilPaint);

    // Angry eyebrow
    final eyebrowPaint = Paint()
      ..color = const Color(0xFF1B5E20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx + radius * 0.1, center.dy - radius * 0.5),
      Offset(center.dx + radius * 0.5, center.dy - radius * 0.4),
      eyebrowPaint,
    );

    _drawStandardBeak(canvas, center, radius);
  }

  // Eagle - Fierce predator with feathers and long beak
  void _drawEagle(Canvas canvas, Offset center, double radius) {
    // Eagle body with brown gradient
    final bodyGradient = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF8D6E63),
          const Color(0xFF5D4037),
          const Color(0xFF3E2723),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyGradient);

    // Feather texture on body
    final featherPaint = Paint()
      ..color = const Color(0xFF3E2723).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 3.14159 * 2;
      final startX = center.dx + radius * 0.3 * math.cos(angle);
      final startY = center.dy + radius * 0.3 * math.sin(angle);
      final endX = center.dx + radius * 0.7 * math.cos(angle);
      final endY = center.dy + radius * 0.7 * math.sin(angle);
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), featherPaint);
    }

    // Eagle wing with feathers
    final wingFeatherPaint = Paint()
      ..color = const Color(0xFF4E342E)
      ..style = PaintingStyle.fill;

    final wingAngle = (bird.velocity / 10) * math.pi / 4;
    for (int i = 0; i < 4; i++) {
      final featherPath = Path();
      final offsetY = i * radius * 0.3 + math.sin(wingAngle) * (4 - i) * 3;
      featherPath.moveTo(center.dx - radius * 0.1, center.dy + offsetY);
      featherPath.lineTo(
          center.dx - radius * 1.4, center.dy + radius * 0.4 + offsetY);
      featherPath.lineTo(
          center.dx - radius * 1.3, center.dy + radius * 0.6 + offsetY);
      featherPath.lineTo(
          center.dx - radius * 0.2, center.dy + radius * 0.3 + offsetY);
      featherPath.close();
      canvas.drawPath(featherPath, wingFeatherPaint);

      final featherOutline = Paint()
        ..color = const Color(0xFF3E2723)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawPath(featherPath, featherOutline);
    }

    // Fierce eagle eyes
    final eyeWhitePaint = Paint()
      ..color = const Color(0xFFFFF8DC)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx + radius * 0.3, center.dy - radius * 0.3),
        radius * 0.32,
        eyeWhitePaint);

    final pupilPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx + radius * 0.4, center.dy - radius * 0.25),
        radius * 0.12,
        pupilPaint);

    final shinePaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx + radius * 0.42, center.dy - radius * 0.28),
        radius * 0.06,
        shinePaint);

    // Fierce eyebrow ridge
    final browPaint = Paint()
      ..color = const Color(0xFF3E2723)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx + radius * 0.05, center.dy - radius * 0.5),
      Offset(center.dx + radius * 0.55, center.dy - radius * 0.45),
      browPaint,
    );

    // Long curved eagle beak
    final beakPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    final beakPath = Path();
    beakPath.moveTo(center.dx + radius * 0.7, center.dy - 6);
    beakPath.quadraticBezierTo(
      center.dx + radius * 1.3,
      center.dy - 3,
      center.dx + radius * 1.5,
      center.dy + 2,
    );
    beakPath.quadraticBezierTo(
      center.dx + radius * 1.3,
      center.dy + 4,
      center.dx + radius * 0.7,
      center.dy + 6,
    );
    beakPath.close();
    canvas.drawPath(beakPath, beakPaint);

    final beakOutline = Paint()
      ..color = const Color(0xFFFF8F00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(beakPath, beakOutline);

    // Hooked tip of beak
    final hookPath = Path();
    hookPath.moveTo(center.dx + radius * 1.5, center.dy + 2);
    hookPath.quadraticBezierTo(
      center.dx + radius * 1.6,
      center.dy + 5,
      center.dx + radius * 1.4,
      center.dy + 7,
    );
    final hookPaint = Paint()
      ..color = const Color(0xFFFF8F00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(hookPath, hookPaint);
  }

  // Hawk - Swift and agile
  void _drawHawk(Canvas canvas, Offset center, double radius) {
    // Hawk body with lighter brown/tan colors
    final bodyGradient = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFBCAAA4),
          const Color(0xFF8D6E63),
          const Color(0xFF6D4C41),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyGradient);

    // Spotted feather pattern
    final spotPaint = Paint()
      ..color = const Color(0xFF4E342E).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(center.dx - radius * 0.3, center.dy - radius * 0.2),
        3,
        spotPaint);
    canvas.drawCircle(
        Offset(center.dx + radius * 0.2, center.dy + radius * 0.3),
        2.5,
        spotPaint);
    canvas.drawCircle(
        Offset(center.dx - radius * 0.1, center.dy + radius * 0.4),
        3.5,
        spotPaint);
    canvas.drawCircle(
        Offset(center.dx + radius * 0.4, center.dy - radius * 0.1),
        2,
        spotPaint);

    // Swift, sleek wings
    final wingPaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFFBCAAA4), const Color(0xFF6D4C41)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final wingAngle = (bird.velocity / 10) * math.pi / 4;
    final wingPath = Path();
    wingPath.moveTo(center.dx - radius * 0.1, center.dy - radius * 0.3);
    wingPath.lineTo(center.dx - radius * 1.0,
        center.dy + radius * 0.2 + math.sin(wingAngle) * 12);
    wingPath.lineTo(center.dx - radius * 0.9, center.dy + radius * 0.5);
    wingPath.lineTo(center.dx - radius * 0.3, center.dy + radius * 0.4);
    wingPath.close();
    canvas.drawPath(wingPath, wingPaint);

    final wingOutline = Paint()
      ..color = const Color(0xFF4E342E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(wingPath, wingOutline);

    // Wing feather details
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(
        Offset(center.dx - radius * 0.3 - i * radius * 0.2,
            center.dy + radius * 0.25),
        Offset(center.dx - radius * 0.5 - i * radius * 0.2,
            center.dy + radius * 0.45),
        wingOutline,
      );
    }

    // Sharp hawk eyes
    final eyeWhitePaint = Paint()
      ..color = const Color(0xFFFFF8DC)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx + radius * 0.35, center.dy - radius * 0.25),
        radius * 0.3,
        eyeWhitePaint);

    final pupilPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx + radius * 0.42, center.dy - radius * 0.22),
        radius * 0.14,
        pupilPaint);

    final shinePaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx + radius * 0.45, center.dy - radius * 0.26),
        radius * 0.06,
        shinePaint);

    // Sharp curved beak
    final beakPaint = Paint()
      ..color = const Color(0xFF424242)
      ..style = PaintingStyle.fill;

    final beakPath = Path();
    beakPath.moveTo(center.dx + radius * 0.7, center.dy - 5);
    beakPath.quadraticBezierTo(
      center.dx + radius * 1.2,
      center.dy - 2,
      center.dx + radius * 1.4,
      center.dy + 1,
    );
    beakPath.lineTo(center.dx + radius * 1.3, center.dy + 3);
    beakPath.quadraticBezierTo(
      center.dx + radius * 1.1,
      center.dy + 2,
      center.dx + radius * 0.7,
      center.dy + 5,
    );
    beakPath.close();
    canvas.drawPath(beakPath, beakPaint);

    final beakHighlight = Paint()
      ..color = const Color(0xFF757575)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(beakPath, beakHighlight);
  }

  // Aaron - Gym buff with beard and workout outfit
  void _drawAaron(Canvas canvas, Offset center, double radius) {
    // Muscular body with tan/peach gradient
    final bodyGradient = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFCC80),
          const Color(0xFFFF9800),
          const Color(0xFFF57C00),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyGradient);

    // Muscle definition - arms/pecs
    final musclePaint = Paint()
      ..color = const Color(0xFFE65100)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Left pec
    final leftPec = Path();
    leftPec.moveTo(center.dx - radius * 0.1, center.dy - radius * 0.3);
    leftPec.quadraticBezierTo(
      center.dx - radius * 0.4,
      center.dy - radius * 0.1,
      center.dx - radius * 0.5,
      center.dy + radius * 0.2,
    );
    canvas.drawPath(leftPec, musclePaint);

    // Right pec
    final rightPec = Path();
    rightPec.moveTo(center.dx + radius * 0.1, center.dy - radius * 0.3);
    rightPec.quadraticBezierTo(
      center.dx + radius * 0.4,
      center.dy - radius * 0.1,
      center.dx + radius * 0.5,
      center.dy + radius * 0.2,
    );
    canvas.drawPath(rightPec, musclePaint);

    // Body hair on lower body (below wings)
    final bodyHairPaint = Paint()
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Scattered body hair on lower body area - spread out naturally
    // Left side lower body
    canvas.drawLine(
      Offset(center.dx - radius * 0.3, center.dy + radius * 0.25),
      Offset(center.dx - radius * 0.2, center.dy + radius * 0.35),
      bodyHairPaint,
    );
    canvas.drawLine(
      Offset(center.dx - radius * 0.25, center.dy + radius * 0.35),
      Offset(center.dx - radius * 0.15, center.dy + radius * 0.42),
      bodyHairPaint,
    );
    canvas.drawLine(
      Offset(center.dx - radius * 0.35, center.dy + radius * 0.45),
      Offset(center.dx - radius * 0.25, center.dy + radius * 0.5),
      bodyHairPaint,
    );
    canvas.drawLine(
      Offset(center.dx - radius * 0.2, center.dy + radius * 0.5),
      Offset(center.dx - radius * 0.1, center.dy + radius * 0.55),
      bodyHairPaint,
    );
    canvas.drawLine(
      Offset(center.dx - radius * 0.15, center.dy + radius * 0.6),
      Offset(center.dx - radius * 0.05, center.dy + radius * 0.65),
      bodyHairPaint,
    );

    // Right side lower body
    canvas.drawLine(
      Offset(center.dx + radius * 0.3, center.dy + radius * 0.25),
      Offset(center.dx + radius * 0.2, center.dy + radius * 0.35),
      bodyHairPaint,
    );
    canvas.drawLine(
      Offset(center.dx + radius * 0.25, center.dy + radius * 0.35),
      Offset(center.dx + radius * 0.15, center.dy + radius * 0.42),
      bodyHairPaint,
    );
    canvas.drawLine(
      Offset(center.dx + radius * 0.35, center.dy + radius * 0.45),
      Offset(center.dx + radius * 0.25, center.dy + radius * 0.5),
      bodyHairPaint,
    );
    canvas.drawLine(
      Offset(center.dx + radius * 0.2, center.dy + radius * 0.5),
      Offset(center.dx + radius * 0.1, center.dy + radius * 0.55),
      bodyHairPaint,
    );
    canvas.drawLine(
      Offset(center.dx + radius * 0.15, center.dy + radius * 0.6),
      Offset(center.dx + radius * 0.05, center.dy + radius * 0.65),
      bodyHairPaint,
    );

    // Center lower body
    canvas.drawLine(
      Offset(center.dx - radius * 0.05, center.dy + radius * 0.4),
      Offset(center.dx + radius * 0.05, center.dy + radius * 0.45),
      bodyHairPaint,
    );
    canvas.drawLine(
      Offset(center.dx - radius * 0.08, center.dy + radius * 0.55),
      Offset(center.dx + radius * 0.02, center.dy + radius * 0.58),
      bodyHairPaint,
    );
    canvas.drawLine(
      Offset(center.dx + radius * 0.03, center.dy + radius * 0.65),
      Offset(center.dx - radius * 0.03, center.dy + radius * 0.7),
      bodyHairPaint,
    );

    // Additional lowermost body hair for professional appearance
    canvas.drawLine(
      Offset(center.dx - radius * 0.1, center.dy + radius * 0.72),
      Offset(center.dx - radius * 0.02, center.dy + radius * 0.78),
      bodyHairPaint,
    );
    canvas.drawLine(
      Offset(center.dx + radius * 0.1, center.dy + radius * 0.72),
      Offset(center.dx + radius * 0.02, center.dy + radius * 0.78),
      bodyHairPaint,
    );
    canvas.drawLine(
      Offset(center.dx - radius * 0.12, center.dy + radius * 0.8),
      Offset(center.dx - radius * 0.05, center.dy + radius * 0.85),
      bodyHairPaint,
    );
    canvas.drawLine(
      Offset(center.dx + radius * 0.12, center.dy + radius * 0.8),
      Offset(center.dx + radius * 0.05, center.dy + radius * 0.85),
      bodyHairPaint,
    );
    canvas.drawLine(
      Offset(center.dx - radius * 0.08, center.dy + radius * 0.88),
      Offset(center.dx, center.dy + radius * 0.92),
      bodyHairPaint,
    );
    canvas.drawLine(
      Offset(center.dx + radius * 0.08, center.dy + radius * 0.88),
      Offset(center.dx, center.dy + radius * 0.92),
      bodyHairPaint,
    );

    // Muscular arms/wings with animation - bigger and more prominent
    final armPaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFFFFCC80), const Color(0xFFF57C00)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final wingAngle = (bird.velocity / 10) * math.pi / 4;
    final armPath = Path();
    armPath.moveTo(center.dx - radius * 0.35, center.dy - radius * 0.2);
    armPath.lineTo(center.dx - radius * 1.3,
        center.dy + radius * 0.2 + math.sin(wingAngle) * 12);
    armPath.lineTo(center.dx - radius * 1.2,
        center.dy + radius * 0.6 + math.sin(wingAngle) * 8);
    armPath.lineTo(center.dx - radius * 0.3, center.dy + radius * 0.4);
    armPath.close();
    canvas.drawPath(armPath, armPaint);
    canvas.drawPath(armPath, musclePaint);

    // Bicep bulge - positioned on larger arm with animation
    canvas.drawCircle(
      Offset(center.dx - radius * 0.85,
          center.dy + radius * 0.25 + math.sin(wingAngle) * 6),
      radius * 0.2,
      Paint()
        ..color = const Color(0xFFE65100)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Determined eyes
    final eyeWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + radius * 0.25, center.dy - radius * 0.35),
      radius * 0.25,
      eyeWhitePaint,
    );

    final pupilPaint = Paint()
      ..color = const Color(0xFF4E342E)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + radius * 0.3, center.dy - radius * 0.32),
      radius * 0.12,
      pupilPaint,
    );

    // Determined eyebrow
    final browPaint = Paint()
      ..color = const Color(0xFF4E342E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx + radius * 0.05, center.dy - radius * 0.55),
      Offset(center.dx + radius * 0.45, center.dy - radius * 0.5),
      browPaint,
    );

    // Beard
    final beardPaint = Paint()
      ..color = const Color(0xFF3E2723)
      ..style = PaintingStyle.fill;

    // Beard base
    final beardPath = Path();
    beardPath.moveTo(center.dx + radius * 0.5, center.dy - radius * 0.1);
    beardPath.quadraticBezierTo(
      center.dx + radius * 0.6,
      center.dy + radius * 0.3,
      center.dx + radius * 0.4,
      center.dy + radius * 0.5,
    );
    beardPath.lineTo(center.dx + radius * 0.5, center.dy + radius * 0.3);
    beardPath.quadraticBezierTo(
      center.dx + radius * 0.55,
      center.dy + radius * 0.15,
      center.dx + radius * 0.5,
      center.dy - radius * 0.1,
    );
    beardPath.close();
    canvas.drawPath(beardPath, beardPaint);

    // Beard texture lines
    final beardTexture = Paint()
      ..color = const Color(0xFF1B1B1B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(center.dx + radius * 0.5, center.dy + i * radius * 0.1),
        Offset(center.dx + radius * 0.55,
            center.dy + radius * 0.05 + i * radius * 0.1),
        beardTexture,
      );
    }

    _drawStandardBeak(canvas, center, radius);

    // Sweatband on head - positioned higher to avoid wing overlap
    final sweatbandPaint = Paint()
      ..color = const Color(0xFFE53935)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5;
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(center.dx, center.dy - radius * 0.15),
          radius: radius * 0.85),
      -3.3,
      2.3,
      false,
      sweatbandPaint,
    );
  }

  // Angel - Divine guardian with aura and large wings
  void _drawAngel(Canvas canvas, Offset center, double radius) {
    // Divine aura glow
    final auraPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(center, radius * 1.3, auraPaint);

    final auraRing = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, radius * 1.15, auraRing);

    // Angel body with pure white gradient
    final bodyGradient = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFFFFF),
          const Color(0xFFF5F5F5),
          const Color(0xFFE0E0E0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyGradient);

    // Halo above head
    final haloPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(
      Offset(center.dx, center.dy - radius * 1.2),
      radius * 0.4,
      haloPaint,
    );

    // Large angel wings with 3 primary feathers each - bigger than eagle with animation
    final wingFeatherPaint = Paint()
      ..color = const Color(0xFFFAFAFA)
      ..style = PaintingStyle.fill;

    final wingAngle = (bird.velocity / 10) * math.pi / 4;
    // Primary wing feathers (3 large feathers)
    for (int i = 0; i < 3; i++) {
      final featherPath = Path();
      final offsetY = i * radius * 0.4 + math.sin(wingAngle) * (3 - i) * 4;
      featherPath.moveTo(
          center.dx - radius * 0.05, center.dy + offsetY - radius * 0.1);
      featherPath.lineTo(
          center.dx - radius * 1.6, center.dy + radius * 0.45 + offsetY);
      featherPath.lineTo(
          center.dx - radius * 1.5, center.dy + radius * 0.7 + offsetY);
      featherPath.lineTo(
          center.dx - radius * 0.15, center.dy + radius * 0.35 + offsetY);
      featherPath.close();
      canvas.drawPath(featherPath, wingFeatherPaint);

      // Feather highlights
      final featherHighlight = Paint()
        ..color = const Color(0xFFFFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawPath(featherPath, featherHighlight);

      // Feather texture lines
      final featherTexture = Paint()
        ..color = const Color(0xFFE0E0E0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      for (int j = 0; j < 4; j++) {
        final startX = center.dx - radius * 0.15 - (j * radius * 0.3);
        final startY = center.dy + offsetY + radius * 0.2 + (j * radius * 0.1);
        final endX = startX - radius * 0.2;
        final endY = startY + radius * 0.15;
        canvas.drawLine(
            Offset(startX, startY), Offset(endX, endY), featherTexture);
      }
    }

    // Red glowing eyes
    final eyeGlowPaint = Paint()
      ..color = const Color(0xFFFF0000).withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(
        Offset(center.dx + radius * 0.3, center.dy - radius * 0.2),
        radius * 0.3,
        eyeGlowPaint);

    final eyePaint = Paint()
      ..color = const Color(0xFFFF0000)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx + radius * 0.3, center.dy - radius * 0.2),
        radius * 0.2,
        eyePaint);

    // Eye shine for glowing effect
    final shinePaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx + radius * 0.35, center.dy - radius * 0.25),
        radius * 0.08,
        shinePaint);

    // Gentle curved beak
    final beakPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    final beakPath = Path();
    beakPath.moveTo(center.dx + radius * 0.7, center.dy - 4);
    beakPath.quadraticBezierTo(
      center.dx + radius * 1.2,
      center.dy - 2,
      center.dx + radius * 1.3,
      center.dy,
    );
    beakPath.lineTo(center.dx + radius * 0.7, center.dy + 4);
    beakPath.close();
    canvas.drawPath(beakPath, beakPaint);

    final beakOutline = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(beakPath, beakOutline);
  }

  // Filipino - Dark-skinned bird with blonde hair and Philippine flag
  void _drawFilipino(Canvas canvas, Offset center, double radius) {
    // Dark skin body with brown gradient
    final bodyGradient = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF8B4513),
          const Color(0xFF654321),
          const Color(0xFF4A3520),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyGradient);

    // Body outline
    final bodyOutlinePaint = Paint()
      ..color = const Color(0xFF2F1F14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(center, radius, bodyOutlinePaint);

    // Blonde hair on top of head
    final hairPaint = Paint()
      ..color = const Color(0xFFFFEB3B)
      ..style = PaintingStyle.fill;

    // Hair strands - blonde spiky hair
    for (int i = 0; i < 5; i++) {
      final hairPath = Path();
      final hairX = center.dx + (i - 2) * radius * 0.25;
      final hairY = center.dy - radius * 0.9;

      hairPath.moveTo(
          center.dx + (i - 2) * radius * 0.2, center.dy - radius * 0.7);
      hairPath.quadraticBezierTo(
        hairX,
        hairY - radius * 0.2,
        hairX + (i - 2) * radius * 0.1,
        hairY - radius * 0.3,
      );
      hairPath.lineTo(hairX + (i - 2) * radius * 0.05, hairY - radius * 0.1);
      hairPath.close();
      canvas.drawPath(hairPath, hairPaint);

      // Hair highlights
      final hairHighlight = Paint()
        ..color = const Color(0xFFFFFDE7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawPath(hairPath, hairHighlight);
    }

    // Three feather wings with animation
    final featherPaint = Paint()
      ..color = const Color(0xFF654321)
      ..style = PaintingStyle.fill;

    final wingAngle = (bird.velocity / 10) * math.pi / 4;
    for (int i = 0; i < 3; i++) {
      final featherPath = Path();
      final offsetY = i * radius * 0.3;
      final animOffset = math.sin(wingAngle) * (3 - i) * 3;
      featherPath.moveTo(
          center.dx - radius * 0.1, center.dy + offsetY - radius * 0.1);
      featherPath.lineTo(
        center.dx - radius * 1.2,
        center.dy + radius * 0.3 + offsetY + animOffset,
      );
      featherPath.lineTo(
        center.dx - radius * 1.1,
        center.dy + radius * 0.55 + offsetY + animOffset,
      );
      featherPath.lineTo(
          center.dx - radius * 0.2, center.dy + radius * 0.3 + offsetY);
      featherPath.close();
      canvas.drawPath(featherPath, featherPaint);

      // Feather outline
      final featherOutline = Paint()
        ..color = const Color(0xFF4A3520)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawPath(featherPath, featherOutline);

      // Feather texture lines
      for (int j = 0; j < 3; j++) {
        canvas.drawLine(
          Offset(center.dx - radius * 0.2 - j * radius * 0.3,
              center.dy + offsetY + radius * 0.15),
          Offset(center.dx - radius * 0.3 - j * radius * 0.3,
              center.dy + offsetY + radius * 0.3),
          Paint()
            ..color = const Color(0xFF8B4513)
            ..strokeWidth = 1.5,
        );
      }
    }

    // Proud eyes
    final eyeWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx + radius * 0.3, center.dy - radius * 0.15),
        radius * 0.18,
        eyeWhitePaint);

    final pupilPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx + radius * 0.32, center.dy - radius * 0.15),
        radius * 0.1,
        pupilPaint);

    // Eye shine
    final shinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx + radius * 0.35, center.dy - radius * 0.18),
        radius * 0.05,
        shinePaint);

    // Black beak
    final beakPaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill;

    final beakPath = Path();
    beakPath.moveTo(center.dx + radius * 0.7, center.dy - 5);
    beakPath.quadraticBezierTo(
      center.dx + radius * 1.1,
      center.dy - 2,
      center.dx + radius * 1.2,
      center.dy,
    );
    beakPath.lineTo(center.dx + radius * 1.2, center.dy + 2);
    beakPath.quadraticBezierTo(
      center.dx + radius * 1.1,
      center.dy + 2,
      center.dx + radius * 0.7,
      center.dy + 5,
    );
    beakPath.close();
    canvas.drawPath(beakPath, beakPaint);

    // Philippine flag pole on back/rear of the bird with slight animation
    final flagSway = math.sin(wingAngle * 0.5) * 3;

    // Flag pole (brown stick) - positioned at the rear
    final polePaint = Paint()
      ..color = const Color(0xFF654321)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx - radius * 0.7, center.dy + radius * 0.4),
      Offset(center.dx - radius * 0.7 + flagSway, center.dy - radius * 0.8),
      polePaint,
    );

    // Philippine flag (simplified) - at the rear
    // White triangle
    final flagWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final whiteTriangle = Path();
    whiteTriangle.moveTo(
        center.dx - radius * 0.7 + flagSway, center.dy - radius * 0.8);
    whiteTriangle.lineTo(center.dx + flagSway, center.dy - radius * 1.0);
    whiteTriangle.lineTo(center.dx + flagSway, center.dy - radius * 0.6);
    whiteTriangle.close();
    canvas.drawPath(whiteTriangle, flagWhitePaint);

    // Blue top stripe
    final flagBluePaint = Paint()
      ..color = const Color(0xFF0038A8)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx + flagSway,
        center.dy - radius * 1.0,
        radius * 0.5,
        radius * 0.2,
      ),
      flagBluePaint,
    );

    // Red bottom stripe
    final flagRedPaint = Paint()
      ..color = const Color(0xFFCE1126)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx + flagSway,
        center.dy - radius * 0.8,
        radius * 0.5,
        radius * 0.2,
      ),
      flagRedPaint,
    );

    // Yellow sun in triangle (simplified circle)
    final sunPaint = Paint()
      ..color = const Color(0xFFFCD116)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - radius * 0.45 + flagSway, center.dy - radius * 0.8),
      radius * 0.12,
      sunPaint,
    );

    // Sun rays (8 main rays simplified)
    final rayPaint = Paint()
      ..color = const Color(0xFFFCD116)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      final startX = center.dx -
          radius * 0.45 +
          flagSway +
          math.cos(angle) * radius * 0.12;
      final startY = center.dy - radius * 0.8 + math.sin(angle) * radius * 0.12;
      final endX =
          center.dx - radius * 0.45 + flagSway + math.cos(angle) * radius * 0.2;
      final endY = center.dy - radius * 0.8 + math.sin(angle) * radius * 0.2;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), rayPaint);
    }

    // Three stars in triangle (simplified)
    final starPaint = Paint()
      ..color = const Color(0xFFFCD116)
      ..style = PaintingStyle.fill;
    // Star positions
    canvas.drawCircle(
      Offset(center.dx - radius * 0.35 + flagSway, center.dy - radius * 0.95),
      radius * 0.04,
      starPaint,
    );
    canvas.drawCircle(
      Offset(center.dx - radius * 0.2 + flagSway, center.dy - radius * 0.75),
      radius * 0.04,
      starPaint,
    );
    canvas.drawCircle(
      Offset(center.dx - radius * 0.35 + flagSway, center.dy - radius * 0.65),
      radius * 0.04,
      starPaint,
    );

    // Flag outline
    final flagOutline = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(whiteTriangle, flagOutline);
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx + flagSway,
        center.dy - radius * 1.0,
        radius * 0.5,
        radius * 0.4,
      ),
      flagOutline,
    );
  }

  void _drawStandardEye(Canvas canvas, Offset center, double radius) {
    final eyeWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + radius * 0.3, center.dy - radius * 0.25),
      radius * 0.35,
      eyeWhitePaint,
    );

    final pupilPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + radius * 0.4, center.dy - radius * 0.2),
      radius * 0.18,
      pupilPaint,
    );

    final shinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + radius * 0.45, center.dy - radius * 0.25),
      radius * 0.08,
      shinePaint,
    );
  }

  void _drawStandardBeak(Canvas canvas, Offset center, double radius) {
    final beakPaint = Paint()
      ..color = const Color(0xFFFF9800)
      ..style = PaintingStyle.fill;

    final beakPath = Path();
    beakPath.moveTo(center.dx + radius * 0.7, center.dy - 3);
    beakPath.lineTo(center.dx + radius * 1.4, center.dy);
    beakPath.lineTo(center.dx + radius * 0.7, center.dy + 3);
    beakPath.close();
    canvas.drawPath(beakPath, beakPaint);

    final beakOutline = Paint()
      ..color = const Color(0xFFE65100)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(beakPath, beakOutline);
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) {
    return true; // Always repaint for animation
  }
}
