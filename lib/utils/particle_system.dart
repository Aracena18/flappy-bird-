import 'dart:math' as math;

import 'package:flutter/material.dart';

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  double life;
  double maxLife;
  Color color;
  double size;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.life,
    required this.color,
    this.size = 3.0,
  }) : maxLife = life;

  void update(double dt) {
    x += vx * dt;
    y += vy * dt;
    vy += 200 * dt; // Gravity effect on particles
    life -= dt;
  }

  bool get isDead => life <= 0;

  double get opacity => (life / maxLife).clamp(0.0, 1.0);
}

class ParticleSystem {
  final List<Particle> particles = [];
  final math.Random _random = math.Random();

  void createExplosion(double x, double y, {Color color = Colors.orange, int count = 20}) {
    for (int i = 0; i < count; i++) {
      final angle = _random.nextDouble() * 2 * math.pi;
      final speed = 100 + _random.nextDouble() * 150;
      particles.add(Particle(
        x: x,
        y: y,
        vx: math.cos(angle) * speed,
        vy: math.sin(angle) * speed,
        life: 0.5 + _random.nextDouble() * 0.5,
        color: color,
        size: 2 + _random.nextDouble() * 3,
      ));
    }
  }

  void createTrail(double x, double y, {Color color = Colors.yellow, int count = 3}) {
    for (int i = 0; i < count; i++) {
      particles.add(Particle(
        x: x + (_random.nextDouble() - 0.5) * 10,
        y: y + (_random.nextDouble() - 0.5) * 10,
        vx: -50 + (_random.nextDouble() - 0.5) * 20,
        vy: (_random.nextDouble() - 0.5) * 40,
        life: 0.3 + _random.nextDouble() * 0.3,
        color: color,
        size: 2 + _random.nextDouble() * 2,
      ));
    }
  }

  void createScoreEffect(double x, double y) {
    for (int i = 0; i < 15; i++) {
      final angle = _random.nextDouble() * 2 * math.pi;
      final speed = 50 + _random.nextDouble() * 100;
      particles.add(Particle(
        x: x,
        y: y,
        vx: math.cos(angle) * speed,
        vy: math.sin(angle) * speed - 100,
        life: 0.6 + _random.nextDouble() * 0.4,
        color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
        size: 3 + _random.nextDouble() * 4,
      ));
    }
  }

  void update(double dt) {
    particles.removeWhere((p) => p.isDead);
    for (var particle in particles) {
      particle.update(dt);
    }
  }

  void clear() {
    particles.clear();
  }
}

class ParticlePainter extends CustomPainter {
  final ParticleSystem particleSystem;

  ParticlePainter(this.particleSystem);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particleSystem.particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
