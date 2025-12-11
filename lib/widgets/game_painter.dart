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
      case 8:
        _drawBenedict(canvas, center, radius);
        break;
      case 9:
        _drawBumblebee(canvas, center, radius);
        break;
      case 10:
        _drawJM(canvas, center, radius);
        break;
    }

    // Draw immunity shield if active
    if (isImmune) {
      _drawImmunityShield(canvas, center, radius);
    }
  }

  // Draw immunity shield effect
  void _drawImmunityShield(Canvas canvas, Offset center, double radius) {
    final shieldRadius = radius * 1.8;

    // Outer glowing shield
    final outerShieldPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, shieldRadius, outerShieldPaint);

    // Mid shield layer
    final midShieldPaint = Paint()
      ..color = Colors.lightBlueAccent.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(center, shieldRadius - 2, midShieldPaint);

    // Inner shield core
    final innerShieldPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, shieldRadius - 4, innerShieldPaint);

    // Hexagonal shield pattern
    final hexPath = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * (math.pi / 180);
      final x = center.dx + shieldRadius * 0.9 * math.cos(angle);
      final y = center.dy + shieldRadius * 0.9 * math.sin(angle);
      if (i == 0) {
        hexPath.moveTo(x, y);
      } else {
        hexPath.lineTo(x, y);
      }
    }
    hexPath.close();

    final hexPaint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(hexPath, hexPaint);
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

    // Green curly vine hair slicked back with animation
    final vineHairPaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final hairSway = math.sin((bird.velocity / 10) * math.pi / 6) * 3;

    // Draw curly vine strands (7 vines) falling backward with sway
    for (int i = 0; i < 7; i++) {
      final vinePath = Path();
      // Calculate position along the curved top of the head
      final angle = math.pi / 2 + (i - 3) * 0.2; // Spread vines along curve
      final startX = center.dx + math.cos(angle) * radius;
      final startY = center.dy - math.sin(angle) * radius;
      final sway = hairSway * (1 - i * 0.1);

      vinePath.moveTo(startX, startY);

      // Slick back and fall - curves going backward and downward (EXTENDED for long hair)
      vinePath.quadraticBezierTo(
        startX - radius * 0.15 + sway * 0.3,
        startY - radius * 0.25,
        startX - radius * 0.35 + sway * 0.5,
        startY - radius * 0.15,
      );
      vinePath.quadraticBezierTo(
        startX -
            radius * 0.5 +
            radius * 0.08 * (i % 2 == 0 ? 1 : -1) +
            sway * 0.7,
        startY,
        startX - radius * 0.65 + sway,
        startY + radius * 0.15,
      );
      vinePath.quadraticBezierTo(
        startX -
            radius * 0.75 +
            radius * 0.1 * (i % 2 == 0 ? -1 : 1) +
            sway * 1.2,
        startY + radius * 0.35,
        startX - radius * 0.8 + sway * 1.5,
        startY + radius * 0.5,
      );
      // Additional curves for longer hair
      vinePath.quadraticBezierTo(
        startX -
            radius * 0.95 +
            radius * 0.08 * (i % 2 == 0 ? 1 : -1) +
            sway * 1.8,
        startY + radius * 0.75,
        startX - radius * 1.1 + sway * 2.0,
        startY + radius * 1.0,
      );
      vinePath.quadraticBezierTo(
        startX -
            radius * 1.25 +
            radius * 0.12 * (i % 2 == 0 ? -1 : 1) +
            sway * 2.2,
        startY + radius * 1.35,
        startX - radius * 1.4 + sway * 2.5,
        startY + radius * 1.7,
      );
      vinePath.quadraticBezierTo(
        startX -
            radius * 1.55 +
            radius * 0.1 * (i % 2 == 0 ? 1 : -1) +
            sway * 2.7,
        startY + radius * 2.1,
        startX - radius * 1.65 + sway * 3.0,
        startY + radius * 2.5,
      );

      canvas.drawPath(vinePath, vineHairPaint);
    }

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
    // Muscular body with black/gray fade gradient
    final bodyGradient = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF505050),
          const Color(0xFF303030),
          const Color(0xFF101010),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyGradient);

    // Muscle definition - arms/pecs
    final musclePaint = Paint()
      ..color = const Color(0xFF202020)
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
      ..color = const Color(0xFFFFFFFF)
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

    // Spiky wings with animation - bigger and more prominent
    final armPaint = Paint()
      ..color = const Color(0xFF202020)
      ..style = PaintingStyle.fill;

    final wingAngle = (bird.velocity / 10) * math.pi / 4;

    // Draw spiky wing with multiple sharp points
    final spikyWingPath = Path();
    spikyWingPath.moveTo(center.dx - radius * 0.35, center.dy - radius * 0.2);
    // First spike
    spikyWingPath.lineTo(center.dx - radius * 0.7,
        center.dy + radius * 0.05 + math.sin(wingAngle) * 8);
    spikyWingPath.lineTo(center.dx - radius * 0.85,
        center.dy + radius * 0.15 + math.sin(wingAngle) * 10);
    // Second spike
    spikyWingPath.lineTo(center.dx - radius * 1.0,
        center.dy + radius * 0.2 + math.sin(wingAngle) * 10);
    spikyWingPath.lineTo(center.dx - radius * 1.2,
        center.dy + radius * 0.35 + math.sin(wingAngle) * 12);
    // Third spike
    spikyWingPath.lineTo(center.dx - radius * 1.15,
        center.dy + radius * 0.5 + math.sin(wingAngle) * 10);
    spikyWingPath.lineTo(center.dx - radius * 1.25,
        center.dy + radius * 0.65 + math.sin(wingAngle) * 8);
    // Back to body
    spikyWingPath.lineTo(center.dx - radius * 0.8,
        center.dy + radius * 0.55 + math.sin(wingAngle) * 6);
    spikyWingPath.lineTo(center.dx - radius * 0.3, center.dy + radius * 0.4);
    spikyWingPath.close();
    canvas.drawPath(spikyWingPath, armPaint);
    canvas.drawPath(spikyWingPath, musclePaint);

    // Bicep bulge - positioned on larger arm with animation
    canvas.drawCircle(
      Offset(center.dx - radius * 0.85,
          center.dy + radius * 0.25 + math.sin(wingAngle) * 6),
      radius * 0.2,
      Paint()
        ..color = const Color(0xFF202020)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Glowing white eyes
    final eyeGlowPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(
      Offset(center.dx + radius * 0.25, center.dy - radius * 0.35),
      radius * 0.3,
      eyeGlowPaint,
    );

    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + radius * 0.25, center.dy - radius * 0.35),
      radius * 0.2,
      eyePaint,
    );

    // Determined eyebrow
    final browPaint = Paint()
      ..color = const Color(0xFF909090)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx + radius * 0.05, center.dy - radius * 0.55),
      Offset(center.dx + radius * 0.45, center.dy - radius * 0.5),
      browPaint,
    );

    // Beard (white hair)
    final beardPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
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
      ..color = const Color(0xFFE0E0E0)
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

    // Pure black beak
    final beakPaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill;

    final beakPath = Path();
    beakPath.moveTo(center.dx + radius * 0.7, center.dy - 4);
    beakPath.lineTo(center.dx + radius * 1.2, center.dy);
    beakPath.lineTo(center.dx + radius * 0.7, center.dy + 4);
    beakPath.close();
    canvas.drawPath(beakPath, beakPaint);

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

    // Yellow hair on top of head
    final hairPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    // Hair strands - yellow feather-like hair
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
        ..color = const Color(0xFFFFE57F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawPath(hairPath, hairHighlight);
    }

    // Green hiking bag on back (drawn BEFORE wings and flag)
    final wingAngle = (bird.velocity / 10) * math.pi / 4;
    final bagSway = math.sin(wingAngle * 0.3) * 2;

    final bagPaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.fill;

    // Bag main body - bulkier and moved further left with sway
    final bagBody = Path();
    bagBody.moveTo(
        center.dx - radius * 0.75 + bagSway * 0.5, center.dy - radius * 0.45);
    bagBody.lineTo(
        center.dx - radius * 1.15 + bagSway, center.dy - radius * 0.45);
    bagBody.lineTo(
        center.dx - radius * 1.15 + bagSway, center.dy + radius * 0.45);
    bagBody.lineTo(
        center.dx - radius * 0.75 + bagSway * 0.5, center.dy + radius * 0.45);
    bagBody.close();
    canvas.drawPath(bagBody, bagPaint);

    // Bag outline
    final bagOutline = Paint()
      ..color = const Color(0xFF1B5E20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(bagBody, bagOutline);

    // Top flap
    final flapPaint = Paint()
      ..color = const Color(0xFF1B5E20)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx - radius * 1.15 + bagSway,
        center.dy - radius * 0.5,
        radius * 0.4,
        radius * 0.15,
      ),
      flapPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx - radius * 1.15 + bagSway,
        center.dy - radius * 0.5,
        radius * 0.4,
        radius * 0.15,
      ),
      bagOutline,
    );

    // Bag straps
    final strapPaint = Paint()
      ..color = const Color(0xFF1B5E20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(
          center.dx - radius * 1.05 + bagSway * 0.8, center.dy - radius * 0.35),
      Offset(center.dx - radius * 0.45, center.dy - radius * 0.5),
      strapPaint,
    );
    canvas.drawLine(
      Offset(
          center.dx - radius * 0.85 + bagSway * 0.6, center.dy - radius * 0.35),
      Offset(center.dx - radius * 0.35, center.dy - radius * 0.45),
      strapPaint,
    );

    // Large front pocket
    final pocketPaint = Paint()
      ..color = const Color(0xFF388E3C)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx - radius * 1.08 + bagSway * 0.85,
        center.dy - radius * 0.05,
        radius * 0.28,
        radius * 0.35,
      ),
      pocketPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx - radius * 1.08 + bagSway * 0.85,
        center.dy - radius * 0.05,
        radius * 0.28,
        radius * 0.35,
      ),
      bagOutline,
    );

    // Side pocket details
    canvas.drawLine(
      Offset(
          center.dx - radius * 0.8 + bagSway * 0.5, center.dy - radius * 0.2),
      Offset(
          center.dx - radius * 0.8 + bagSway * 0.5, center.dy + radius * 0.2),
      bagOutline,
    );

    // Philippine flag pole on back/rear of the bird (drawn AFTER bag, BEFORE wings)
    final flagSway = math.sin(wingAngle * 0.5) * 3;

    // Flag pole (black stick) - positioned at the rear
    final polePaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx - radius * 0.7, center.dy + radius * 0.4),
      Offset(
          center.dx - radius * 0.7 + flagSway * 0.3, center.dy - radius * 0.8),
      polePaint,
    );

    // Philippine flag (complete rectangle) - facing LEFT with animation
    // Blue top stripe (hoist on left, extending left)
    final flagBluePaint = Paint()
      ..color = const Color(0xFF0038A8)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx - radius * 1.3 + flagSway,
        center.dy - radius * 0.8,
        radius * 0.6,
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
        center.dx - radius * 1.3 + flagSway,
        center.dy - radius * 0.6,
        radius * 0.6,
        radius * 0.2,
      ),
      flagRedPaint,
    );

    // White triangle (hoist side)
    final flagWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final whiteTriangle = Path();
    whiteTriangle.moveTo(
        center.dx - radius * 0.7 + flagSway * 0.3, center.dy - radius * 0.8);
    whiteTriangle.lineTo(
        center.dx - radius * 0.7 + flagSway * 0.3, center.dy - radius * 0.4);
    whiteTriangle.lineTo(
        center.dx - radius * 1.0 + flagSway * 0.7, center.dy - radius * 0.6);
    whiteTriangle.close();
    canvas.drawPath(whiteTriangle, flagWhitePaint);

    // Yellow sun in triangle
    final sunPaint = Paint()
      ..color = const Color(0xFFFCD116)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(
          center.dx - radius * 0.85 + flagSway * 0.5, center.dy - radius * 0.6),
      radius * 0.08,
      sunPaint,
    );

    // Sun rays (8 main rays)
    final rayPaint = Paint()
      ..color = const Color(0xFFFCD116)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      final startX = center.dx -
          radius * 0.85 +
          flagSway * 0.5 +
          math.cos(angle) * radius * 0.08;
      final startY = center.dy - radius * 0.6 + math.sin(angle) * radius * 0.08;
      final endX = center.dx -
          radius * 0.85 +
          flagSway * 0.5 +
          math.cos(angle) * radius * 0.14;
      final endY = center.dy - radius * 0.6 + math.sin(angle) * radius * 0.14;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), rayPaint);
    }

    // Three stars in triangle
    final starPaint = Paint()
      ..color = const Color(0xFFFCD116)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - radius * 0.82 + flagSway * 0.5,
          center.dy - radius * 0.52),
      radius * 0.03,
      starPaint,
    );
    canvas.drawCircle(
      Offset(
          center.dx - radius * 0.92 + flagSway * 0.6, center.dy - radius * 0.6),
      radius * 0.03,
      starPaint,
    );
    canvas.drawCircle(
      Offset(center.dx - radius * 0.82 + flagSway * 0.5,
          center.dy - radius * 0.68),
      radius * 0.03,
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
        center.dx - radius * 1.3 + flagSway,
        center.dy - radius * 0.8,
        radius * 0.6,
        radius * 0.4,
      ),
      flagOutline,
    );

    // Three feather wings with animation
    final featherPaint = Paint()
      ..color = const Color(0xFF654321)
      ..style = PaintingStyle.fill;

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
  }

  // Benedict - White bird with 3 sharp black wings, sharp beak, and glowing black eyes
  void _drawBenedict(Canvas canvas, Offset center, double radius) {
    // Pure white body with subtle gradient
    final bodyGradient = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFFFFF),
          const Color(0xFFF5F5F5),
          const Color(0xFFEEEEEE),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyGradient);

    // Body outline
    final bodyOutlinePaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, bodyOutlinePaint);

    // Three sleek black wings with animation - sharp blade-like design
    final wingPaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill;

    // Wing animation based on bird velocity
    final wingAngle = (bird.velocity / 10) * math.pi / 3;
    final wingSpread = math.sin(wingAngle) * 8;

    // First wing (topmost) - sleek and elongated
    final wing1Path = Path();
    wing1Path.moveTo(center.dx - radius * 0.15, center.dy - radius * 0.35);
    // Sharp leading edge
    wing1Path.quadraticBezierTo(
      center.dx - radius * 0.8,
      center.dy - radius * 0.25 + wingSpread * 0.8,
      center.dx - radius * 1.6,
      center.dy - radius * 0.05 + wingSpread,
    );
    // Sharp trailing edge
    wing1Path.quadraticBezierTo(
      center.dx - radius * 1.5,
      center.dy + wingSpread * 0.5,
      center.dx - radius * 0.25,
      center.dy - radius * 0.15,
    );
    wing1Path.close();
    canvas.drawPath(wing1Path, wingPaint);

    // Second wing (middle) - wider and more prominent
    final wing2Path = Path();
    wing2Path.moveTo(center.dx - radius * 0.1, center.dy);
    // Sharp leading edge
    wing2Path.quadraticBezierTo(
      center.dx - radius * 0.9,
      center.dy + radius * 0.15 + wingSpread * 1.2,
      center.dx - radius * 1.7,
      center.dy + radius * 0.35 + wingSpread * 1.5,
    );
    // Sharp trailing edge
    wing2Path.quadraticBezierTo(
      center.dx - radius * 1.55,
      center.dy + radius * 0.45 + wingSpread,
      center.dx - radius * 0.2,
      center.dy + radius * 0.15,
    );
    wing2Path.close();
    canvas.drawPath(wing2Path, wingPaint);

    // Third wing (bottom) - sleek taper
    final wing3Path = Path();
    wing3Path.moveTo(center.dx - radius * 0.15, center.dy + radius * 0.35);
    // Sharp leading edge
    wing3Path.quadraticBezierTo(
      center.dx - radius * 0.75,
      center.dy + radius * 0.55 + wingSpread * 0.6,
      center.dx - radius * 1.4,
      center.dy + radius * 0.75 + wingSpread * 0.8,
    );
    // Sharp trailing edge
    wing3Path.quadraticBezierTo(
      center.dx - radius * 1.25,
      center.dy + radius * 0.85 + wingSpread * 0.4,
      center.dx - radius * 0.25,
      center.dy + radius * 0.55,
    );
    wing3Path.close();
    canvas.drawPath(wing3Path, wingPaint);

    // Gradient effect on wings for sleek appearance
    final wingGradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF1A1A1A),
          const Color(0xFF000000),
          const Color(0xFF0D0D0D),
        ],
      ).createShader(Rect.fromLTRB(
        center.dx - radius * 1.7,
        center.dy - radius * 0.4,
        center.dx,
        center.dy + radius * 0.9,
      ));
    canvas.drawPath(wing1Path, wingGradientPaint);
    canvas.drawPath(wing2Path, wingGradientPaint);
    canvas.drawPath(wing3Path, wingGradientPaint);

    // Sharp edge highlights for sleek look
    final wingEdgePaint = Paint()
      ..color = const Color(0xFF333333)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(wing1Path, wingEdgePaint);
    canvas.drawPath(wing2Path, wingEdgePaint);
    canvas.drawPath(wing3Path, wingEdgePaint);

    // Glowing black eyes - outer glow
    final outerGlowPaint = Paint()
      ..color = const Color(0xFF000000).withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(
        Offset(center.dx + radius * 0.3, center.dy - radius * 0.2),
        radius * 0.45,
        outerGlowPaint);

    // Mid glow layer
    final midGlowPaint = Paint()
      ..color = const Color(0xFF1A1A1A).withOpacity(0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(
        Offset(center.dx + radius * 0.3, center.dy - radius * 0.2),
        radius * 0.35,
        midGlowPaint);

    // Eye base - dark center
    final eyeBasePaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx + radius * 0.3, center.dy - radius * 0.2),
        radius * 0.28,
        eyeBasePaint);

    // Black iris
    final irisPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF333333), // Dark gray center
          const Color(0xFF1A1A1A), // Darker gray
          const Color(0xFF000000), // Black rim
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(center.dx + radius * 0.3, center.dy - radius * 0.2),
        radius: radius * 0.22,
      ));
    canvas.drawCircle(
        Offset(center.dx + radius * 0.3, center.dy - radius * 0.2),
        radius * 0.22,
        irisPaint);

    // Dark pupil
    final pupilPaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx + radius * 0.3, center.dy - radius * 0.2),
        radius * 0.08,
        pupilPaint);

    // Sharp thin black beak
    final beakPaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.fill;

    final beakPath = Path();
    beakPath.moveTo(center.dx + radius * 0.7, center.dy - 2);
    beakPath.lineTo(center.dx + radius * 1.5, center.dy);
    beakPath.lineTo(center.dx + radius * 0.7, center.dy + 2);
    beakPath.close();
    canvas.drawPath(beakPath, beakPaint);

    // Beak sharp edge
    final beakEdgePaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(beakPath, beakEdgePaint);
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

  // Bumblebee - Transformer autobot with animated car door wings
  void _drawBumblebee(Canvas canvas, Offset center, double radius) {
    // Wing animation based on velocity
    final wingAngle = (bird.velocity / 15) * math.pi / 4;
    final doorSwing = math.sin(wingAngle) * 12;

    // Yellow and black striped body
    final bodyGradient = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFEB3B),
          const Color(0xFFFFC107),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyGradient);

    // Black racing stripes
    final stripePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final leftStripe = Path();
    leftStripe.moveTo(center.dx - radius * 0.3, center.dy - radius);
    leftStripe.lineTo(center.dx - radius * 0.1, center.dy - radius);
    leftStripe.lineTo(center.dx - radius * 0.1, center.dy + radius);
    leftStripe.lineTo(center.dx - radius * 0.3, center.dy + radius);
    leftStripe.close();
    canvas.drawPath(leftStripe, stripePaint);

    final rightStripe = Path();
    rightStripe.moveTo(center.dx + radius * 0.1, center.dy - radius);
    rightStripe.lineTo(center.dx + radius * 0.3, center.dy - radius);
    rightStripe.lineTo(center.dx + radius * 0.3, center.dy + radius);
    rightStripe.lineTo(center.dx + radius * 0.1, center.dy + radius);
    rightStripe.close();
    canvas.drawPath(rightStripe, stripePaint);

    // Autobot insignia
    final insigniaPaint = Paint()
      ..color = const Color(0xFFD32F2F)
      ..style = PaintingStyle.fill;

    final insigniaPath = Path();
    insigniaPath.moveTo(center.dx, center.dy - radius * 0.2);
    insigniaPath.lineTo(center.dx - radius * 0.15, center.dy + radius * 0.1);
    insigniaPath.lineTo(center.dx, center.dy);
    insigniaPath.lineTo(center.dx + radius * 0.15, center.dy + radius * 0.1);
    insigniaPath.close();
    canvas.drawPath(insigniaPath, insigniaPaint);

    // Animated car door wing - opens/closes with velocity
    final doorPaint = Paint()
      ..color = const Color(0xFFFFC107) // Yellow door
      ..style = PaintingStyle.fill;

    canvas.save();
    // Rotate around hinge point for door swing animation
    canvas.translate(center.dx - radius * 0.2, center.dy);
    canvas.rotate(doorSwing * 0.05);
    canvas.translate(-(center.dx - radius * 0.2), -center.dy);

    final leftDoor = Path();
    leftDoor.moveTo(center.dx - radius * 0.2, center.dy - radius * 0.4);
    leftDoor.lineTo(center.dx - radius * 1.6, center.dy - radius * 0.3);
    leftDoor.lineTo(center.dx - radius * 1.7, center.dy + radius * 0.8);
    leftDoor.lineTo(center.dx - radius * 0.3, center.dy + radius * 0.8);
    leftDoor.close();
    canvas.drawPath(leftDoor, doorPaint);

    // Door window with black glass
    final windowPaint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final window = Path();
    window.moveTo(center.dx - radius * 0.4, center.dy - radius * 0.25);
    window.lineTo(center.dx - radius * 1.4, center.dy - radius * 0.15);
    window.lineTo(center.dx - radius * 1.45, center.dy + radius * 0.4);
    window.lineTo(center.dx - radius * 0.45, center.dy + radius * 0.45);
    window.close();
    canvas.drawPath(window, windowPaint);

    // Door handle
    final handlePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(center.dx - radius * 1.05, center.dy + radius * 0.15,
          radius * 0.2, radius * 0.1),
      handlePaint,
    );

    // Wing outline
    final doorOutline = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawPath(leftDoor, doorOutline);

    // Mechanical hinges
    final jointPaint = Paint()
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx - radius * 0.2, center.dy - radius * 0.4),
        radius * 0.15,
        jointPaint);
    canvas.drawCircle(
        Offset(center.dx - radius * 0.3, center.dy + radius * 0.8),
        radius * 0.15,
        jointPaint);

    // Hinge detail
    final hingeOutline = Paint()
      ..color = const Color(0xFF616161)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
        Offset(center.dx - radius * 0.2, center.dy - radius * 0.4),
        radius * 0.15,
        hingeOutline);

    canvas.restore();

    // Blue glowing eyes (like Cybird but brighter)
    // Outer glow
    final eyeGlowPaint = Paint()
      ..color = const Color(0xFF2196F3).withOpacity(0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(
      Offset(center.dx + radius * 0.45, center.dy - radius * 0.2),
      radius * 0.3,
      eyeGlowPaint,
    );

    // Mid glow
    final midGlowPaint = Paint()
      ..color = const Color(0xFF64B5F6).withOpacity(0.9)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(
      Offset(center.dx + radius * 0.45, center.dy - radius * 0.2),
      radius * 0.22,
      midGlowPaint,
    );

    // Eye base
    final eyeBasePaint = Paint()
      ..color = const Color(0xFF1976D2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + radius * 0.45, center.dy - radius * 0.2),
      radius * 0.18,
      eyeBasePaint,
    );

    // Bright core
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFE3F2FD),
          const Color(0xFF2196F3),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(center.dx + radius * 0.45, center.dy - radius * 0.2),
        radius: radius * 0.15,
      ));
    canvas.drawCircle(
      Offset(center.dx + radius * 0.45, center.dy - radius * 0.2),
      radius * 0.15,
      corePaint,
    );

    // Helmet crest
    final crestPaint = Paint()
      ..color = const Color(0xFFFFC107)
      ..style = PaintingStyle.fill;

    final crest = Path();
    crest.moveTo(center.dx - radius * 0.35, center.dy - radius * 1.0);
    crest.lineTo(center.dx - radius * 0.12, center.dy - radius * 1.25);
    crest.lineTo(center.dx + radius * 0.12, center.dy - radius * 1.25);
    crest.lineTo(center.dx + radius * 0.35, center.dy - radius * 1.0);
    crest.lineTo(center.dx, center.dy - radius * 0.75);
    crest.close();
    canvas.drawPath(crest, crestPaint);

    final crestOutline = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(crest, crestOutline);

    // Animated antennae
    final antennaAngle = wingAngle * 0.3;
    final antennaPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Left antenna
    canvas.drawLine(
      Offset(center.dx - radius * 0.22, center.dy - radius * 1.25),
      Offset(center.dx - radius * 0.28 + math.sin(antennaAngle) * 3,
          center.dy - radius * 1.45),
      antennaPaint,
    );

    // Right antenna
    canvas.drawLine(
      Offset(center.dx + radius * 0.22, center.dy - radius * 1.25),
      Offset(center.dx + radius * 0.28 - math.sin(antennaAngle) * 3,
          center.dy - radius * 1.45),
      antennaPaint,
    );

    // Antenna tips (glowing)
    final antennaTipPaint = Paint()
      ..color = const Color(0xFF2196F3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(
      Offset(center.dx - radius * 0.28 + math.sin(antennaAngle) * 3,
          center.dy - radius * 1.45),
      radius * 0.1,
      antennaTipPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.28 - math.sin(antennaAngle) * 3,
          center.dy - radius * 1.45),
      radius * 0.1,
      antennaTipPaint,
    );

    // Mouthplate
    final mouthplatePaint = Paint()
      ..color = const Color(0xFF616161)
      ..style = PaintingStyle.fill;

    final mouthplate = Path();
    mouthplate.moveTo(center.dx + radius * 0.55, center.dy + radius * 0.1);
    mouthplate.lineTo(center.dx + radius * 0.9, center.dy + radius * 0.25);
    mouthplate.lineTo(center.dx + radius * 0.8, center.dy + radius * 0.5);
    mouthplate.lineTo(center.dx + radius * 0.55, center.dy + radius * 0.4);
    mouthplate.close();
    canvas.drawPath(mouthplate, mouthplatePaint);

    final mouthOutline = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(mouthplate, mouthOutline);

    // Vent lines on mouthplate
    final ventPaint = Paint()
      ..color = const Color(0xFF424242)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(center.dx + radius * 0.6, center.dy + radius * 0.18),
      Offset(center.dx + radius * 0.7, center.dy + radius * 0.38),
      ventPaint,
    );
    canvas.drawLine(
      Offset(center.dx + radius * 0.68, center.dy + radius * 0.2),
      Offset(center.dx + radius * 0.75, center.dy + radius * 0.42),
      ventPaint,
    );
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) {
    return true; // Always repaint for animation
  }

  void _drawJM(Canvas canvas, Offset center, double radius) {
    // Korean K-pop inspired bird with vibrant colors and modern style
    // Add animation based on bird velocity
    final velocityFactor = (bird.velocity / 10).clamp(-1.0, 1.0);
    final hairSway = math.sin(velocityFactor * math.pi) * 8;
    final wingAngle =
        math.pi / 4 + math.sin(velocityFactor * math.pi * 2) * 0.3;

    // Body - gradient from hot pink to purple (K-pop vibrant colors)
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF1493), // Deep pink
          const Color(0xFFFF69B4), // Hot pink
          const Color(0xFF9C27B0), // Purple accent
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyPaint);

    // Stylish K-pop hair - swept side bang with highlights and animation
    final hairPaint = Paint()
      ..color = const Color(0xFF6A1B9A) // Deep purple hair
      ..style = PaintingStyle.fill;

    // Main hair volume with sway
    final hairPath = Path();
    hairPath.moveTo(center.dx - radius * 0.8, center.dy - radius * 0.3);
    hairPath.quadraticBezierTo(
      center.dx - radius * 0.9 + hairSway,
      center.dy - radius * 1.0,
      center.dx - radius * 0.3 + hairSway * 0.5,
      center.dy - radius * 1.1,
    );
    hairPath.quadraticBezierTo(
      center.dx + radius * 0.2 + hairSway * 0.3,
      center.dy - radius * 1.2,
      center.dx + radius * 0.5,
      center.dy - radius * 0.9,
    );
    hairPath.quadraticBezierTo(
      center.dx + radius * 0.6,
      center.dy - radius * 0.5,
      center.dx + radius * 0.4,
      center.dy - radius * 0.2,
    );
    hairPath.close();
    canvas.drawPath(hairPath, hairPaint);

    // Hair highlights (blonde streaks - common in K-pop) with animation
    final highlightPaint = Paint()
      ..color = const Color(0xFFFFD700) // Gold highlights
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    for (int i = 0; i < 5; i++) {
      final highlightPath = Path();
      final startX =
          center.dx - radius * 0.6 + i * radius * 0.25 + hairSway * 0.3;
      final startY = center.dy - radius * 0.9;
      highlightPath.moveTo(startX, startY);
      highlightPath.quadraticBezierTo(
        startX + radius * 0.1 + hairSway * 0.2,
        startY + radius * 0.3,
        startX + radius * 0.05 + hairSway * 0.1,
        startY + radius * 0.5,
      );
      canvas.drawPath(highlightPath, highlightPaint);
    }

    // Korean headband accessory with pattern
    final headbandPaint = Paint()
      ..color = const Color(0xFF00BCD4) // Cyan headband
      ..style = PaintingStyle.fill;

    final headbandPath = Path();
    headbandPath.addOval(Rect.fromCenter(
      center: Offset(center.dx, center.dy - radius * 0.4),
      width: radius * 1.8,
      height: radius * 0.35,
    ));
    canvas.drawPath(headbandPath, headbandPaint);

    // Headband embroidery pattern with shimmer
    final patternPaint = Paint()
      ..color = Colors.white
          .withOpacity(0.8 + math.sin(velocityFactor * math.pi) * 0.2)
      ..style = PaintingStyle.fill;

    for (int i = -3; i <= 3; i++) {
      canvas.drawCircle(
        Offset(center.dx + i * radius * 0.25, center.dy - radius * 0.4),
        2.0,
        patternPaint,
      );
    }

    // Modern fashion - collar/jacket detail
    final collarPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final collarPath = Path();
    collarPath.moveTo(center.dx - radius * 0.4, center.dy + radius * 0.3);
    collarPath.lineTo(center.dx - radius * 0.5, center.dy + radius * 0.6);
    collarPath.lineTo(center.dx - radius * 0.2, center.dy + radius * 0.5);
    collarPath.close();
    canvas.drawPath(collarPath, collarPaint);

    collarPath.reset();
    collarPath.moveTo(center.dx + radius * 0.4, center.dy + radius * 0.3);
    collarPath.lineTo(center.dx + radius * 0.5, center.dy + radius * 0.6);
    collarPath.lineTo(center.dx + radius * 0.2, center.dy + radius * 0.5);
    collarPath.close();
    canvas.drawPath(collarPath, collarPaint);

    // Stylish wing with gradient and animation
    canvas.save();
    canvas.translate(center.dx + radius * 0.3, center.dy);
    canvas.rotate(wingAngle);

    final wingPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFF1493),
          const Color(0xFF00BCD4),
        ],
      ).createShader(
          Rect.fromLTWH(0, -radius * 0.2, radius * 0.8, radius * 0.6));

    final wingPath = Path();
    wingPath.moveTo(0, 0);
    wingPath.quadraticBezierTo(
      radius * 0.4,
      -radius * 0.3,
      radius * 0.7,
      -radius * 0.1,
    );
    wingPath.quadraticBezierTo(
      radius * 0.6,
      radius * 0.2,
      radius * 0.1,
      radius * 0.2,
    );
    wingPath.close();
    canvas.drawPath(wingPath, wingPaint);

    // Wing details - feather lines
    final featherPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(radius * 0.2, -radius * 0.1 + i * radius * 0.1),
        Offset(radius * 0.55, -radius * 0.05 + i * radius * 0.08),
        featherPaint,
      );
    }

    canvas.restore();

    // Stylish eyes - K-pop eye makeup look
    final eyeWhitePaint = Paint()..color = Colors.white;

    // Left eye
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.25, center.dy - radius * 0.1),
        width: radius * 0.4,
        height: radius * 0.35,
      ),
      eyeWhitePaint,
    );

    // Right eye
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + radius * 0.25, center.dy - radius * 0.1),
        width: radius * 0.4,
        height: radius * 0.35,
      ),
      eyeWhitePaint,
    );

    // Eye makeup - eyeliner effect with shimmer
    final eyelinerPaint = Paint()
      ..color = const Color(0xFF9C27B0) // Purple eyeliner
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Left eye liner
    final leftLiner = Path();
    leftLiner.moveTo(center.dx - radius * 0.45, center.dy - radius * 0.15);
    leftLiner.quadraticBezierTo(
      center.dx - radius * 0.25,
      center.dy - radius * 0.2,
      center.dx - radius * 0.05,
      center.dy - radius * 0.15,
    );
    canvas.drawPath(leftLiner, eyelinerPaint);

    // Right eye liner
    final rightLiner = Path();
    rightLiner.moveTo(center.dx + radius * 0.05, center.dy - radius * 0.15);
    rightLiner.quadraticBezierTo(
      center.dx + radius * 0.25,
      center.dy - radius * 0.2,
      center.dx + radius * 0.45,
      center.dy - radius * 0.15,
    );
    canvas.drawPath(rightLiner, eyelinerPaint);

    // Pupils - sparkly effect
    final pupilPaint = Paint()..color = const Color(0xFF1A237E); // Deep blue
    canvas.drawCircle(
      Offset(center.dx - radius * 0.25, center.dy - radius * 0.1),
      radius * 0.12,
      pupilPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.25, center.dy - radius * 0.1),
      radius * 0.12,
      pupilPaint,
    );

    // Eye sparkles with pulse animation
    final sparkleOpacity = 0.8 + math.sin(velocityFactor * math.pi * 3) * 0.2;
    final sparklePaint = Paint()
      ..color = Colors.white.withOpacity(sparkleOpacity);
    canvas.drawCircle(
      Offset(center.dx - radius * 0.22, center.dy - radius * 0.13),
      radius * 0.04,
      sparklePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.28, center.dy - radius * 0.13),
      radius * 0.04,
      sparklePaint,
    );

    // Cute smile - K-pop style
    final smilePaint = Paint()
      ..color = const Color(0xFFFF1493) // Pink smile
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final smilePath = Path();
    smilePath.moveTo(center.dx - radius * 0.2, center.dy + radius * 0.15);
    smilePath.quadraticBezierTo(
      center.dx,
      center.dy + radius * 0.25,
      center.dx + radius * 0.2,
      center.dy + radius * 0.15,
    );
    canvas.drawPath(smilePath, smilePaint);

    // Beak with gradient - modern style
    final beakPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFFC107), // Amber
          const Color(0xFFFF6F00), // Deep orange
        ],
      ).createShader(Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.05),
        width: radius * 0.3,
        height: radius * 0.25,
      ));

    final beakPath = Path();
    beakPath.moveTo(center.dx - radius * 0.08, center.dy + radius * 0.02);
    beakPath.lineTo(center.dx + radius * 0.08, center.dy + radius * 0.02);
    beakPath.lineTo(center.dx, center.dy + radius * 0.15);
    beakPath.close();
    canvas.drawPath(beakPath, beakPaint);

    // Accessory - small earring/piercing with swing animation
    final earringSwing = math.sin(velocityFactor * math.pi * 2) * 3;
    final earringPaint = Paint()..color = const Color(0xFFFFD700); // Gold
    canvas.drawCircle(
      Offset(center.dx - radius * 0.7, center.dy + earringSwing),
      radius * 0.08,
      earringPaint,
    );

    final earringInner = Paint()..color = const Color(0xFF00BCD4); // Cyan gem
    canvas.drawCircle(
      Offset(center.dx - radius * 0.7, center.dy + earringSwing),
      radius * 0.04,
      earringInner,
    );

    // Outline
    final outlinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius, outlinePaint);
  }
}
