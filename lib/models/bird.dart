import 'dart:ui';

class Bird {
  double x;
  double y;
  double velocity;
  double acceleration;
  final double size;
  final double flapStrength;

  Bird({
    required this.x,
    required this.y,
    this.velocity = 0,
    this.acceleration = 0,
    this.size = 40,
    this.flapStrength = -8, // Reduced from -12 for smoother control
  });

  void flap() {
    velocity = flapStrength;
  }

  void update(double gravity) {
    // Physics: v = v₀ + at
    acceleration = gravity;
    velocity += acceleration;
    
    // Limit velocity to prevent extreme speeds (more forgiving limits)
    if (velocity > 10) velocity = 10;
    if (velocity < -10) velocity = -10;
    
    // Position: s = s₀ + vt
    y += velocity;
  }

  void reset(double screenHeight) {
    y = screenHeight / 2;
    velocity = 0;
    acceleration = 0;
  }

  Rect getRect() {
    return Rect.fromLTWH(x - size / 2, y - size / 2, size, size);
  }
}
