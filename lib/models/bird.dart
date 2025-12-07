import 'dart:ui';

class Bird {
  double x;
  double y;
  double velocity;
  double acceleration;
  final double size;
  final double flapStrength;
  final double maxVelocity;
  final int birdType;

  Bird({
    required this.x,
    required this.y,
    this.velocity = 0,
    this.acceleration = 0,
    this.size = 40,
    this.flapStrength = -8,
    this.maxVelocity = 15,
    this.birdType = 0,
  });

  // Get bird-specific specifications based on bird type
  static BirdSpec getBirdSpec(int birdType) {
    final specs = {
      0: BirdSpec(
          name: 'Robert',
          flapStrength: -15.0,
          size: 40,
          maxVelocity: 15.0,
          optimalPlanet: 'earth'),
      1: BirdSpec(
          name: 'Cybird',
          flapStrength: -6.0,
          size: 42,
          maxVelocity: 8.0,
          optimalPlanet: 'moon'),
      2: BirdSpec(
          name: 'Sierra Madre',
          flapStrength: -18.0,
          size: 44,
          maxVelocity: 15.0,
          optimalPlanet: 'earth'),
      3: BirdSpec(
          name: 'Eagle',
          flapStrength: -19.0,
          size: 42,
          maxVelocity: 15.0,
          optimalPlanet: 'earth'),
      4: BirdSpec(
          name: 'Hawk',
          flapStrength: -17.0,
          size: 38,
          maxVelocity: 15.0,
          optimalPlanet: 'earth'),
      5: BirdSpec(
          name: 'Aaron',
          flapStrength: -70.0,
          size: 46,
          maxVelocity: 12.0,
          optimalPlanet: 'jupiter'),
      6: BirdSpec(
          name: 'Lucifer',
          flapStrength: -16.0,
          size: 40,
          maxVelocity: 18.0,
          optimalPlanet: 'saturn'),
      7: BirdSpec(
          name: 'Philippine Blooper',
          flapStrength: -16.5,
          size: 40,
          maxVelocity: 15.9,
          optimalPlanet: 'earth'),
      8: BirdSpec(
          name: 'Benedict',
          flapStrength: -10.0,
          size: 42,
          maxVelocity: 12.0,
          optimalPlanet: 'mars'),
    };
    return specs[birdType] ?? specs[0]!;
  }

  // Create a bird with specifications for its type
  factory Bird.withType({
    required double x,
    required double y,
    required int birdType,
  }) {
    final spec = getBirdSpec(birdType);
    return Bird(
      x: x,
      y: y,
      size: spec.size,
      flapStrength: spec.flapStrength,
      maxVelocity: spec.maxVelocity,
      birdType: birdType,
    );
  }

  void flap() {
    velocity = flapStrength;
  }

  void update(double gravity) {
    // Physics: v = v₀ + at
    acceleration = gravity;
    velocity += acceleration;

    // Limit velocity to prevent extreme speeds using bird-specific limits
    if (velocity > maxVelocity) velocity = maxVelocity;
    if (velocity < -maxVelocity) velocity = -maxVelocity;

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

class BirdSpec {
  final String name;
  final double flapStrength;
  final double size;
  final double maxVelocity;
  final String optimalPlanet;

  BirdSpec({
    required this.name,
    required this.flapStrength,
    required this.size,
    required this.maxVelocity,
    required this.optimalPlanet,
  });
}
