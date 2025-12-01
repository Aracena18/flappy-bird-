import 'dart:math';

class PhysicsFact {
  final String title;
  final String description;
  final String category; // e.g., 'gravity', 'motion', 'forces', 'energy'
  final String? funFact;

  PhysicsFact({
    required this.title,
    required this.description,
    required this.category,
    this.funFact,
  });
}

class PhysicsFactDatabase {
  static final Random _random = Random();

  static final List<PhysicsFact> facts = [
    PhysicsFact(
      title: 'Gravity',
      description:
          'Gravity is a fundamental force that pulls all objects with mass toward each other. On Earth, it pulls us toward the ground at 9.8 m/s².',
      category: 'gravity',
      funFact:
          'The bird in Flappy Bird experiences constant gravitational acceleration!',
    ),
    PhysicsFact(
      title: 'Velocity vs Speed',
      description:
          'Velocity is speed in a specific direction. When the bird flaps, it gains upward velocity.',
      category: 'motion',
      funFact:
          'The bird\'s velocity changes constantly due to gravity and flapping!',
    ),
    PhysicsFact(
      title: 'Acceleration',
      description:
          'Acceleration is the rate of change of velocity. Gravity causes constant downward acceleration.',
      category: 'motion',
      funFact:
          'A falling object accelerates faster over time - that\'s why the bird gets harder to control!',
    ),
    PhysicsFact(
      title: 'Newton\'s First Law',
      description:
          'An object at rest stays at rest, and an object in motion stays in motion unless acted upon by a force.',
      category: 'forces',
      funFact:
          'Without gravity, the bird would keep moving in one direction forever!',
    ),
    PhysicsFact(
      title: 'Newton\'s Second Law',
      description: 'Force equals mass times acceleration (F = m × a). More force = more acceleration.',
      category: 'forces',
      funFact:
          'The flap force the bird uses must overcome gravity to move upward!',
    ),
    PhysicsFact(
      title: 'Momentum',
      description:
          'Momentum is mass times velocity (p = m × v). It\'s how much "push" an object has.',
      category: 'motion',
      funFact:
          'The bird\'s downward momentum increases as it falls longer!',
    ),
    PhysicsFact(
      title: 'Terminal Velocity',
      description:
          'The maximum speed an object reaches while falling when air resistance equals gravitational force.',
      category: 'motion',
      funFact:
          'A real bird reaches terminal velocity - that\'s why you can\'t fall infinitely fast!',
    ),
    PhysicsFact(
      title: 'Energy',
      description:
          'Energy is the capacity to do work. Kinetic energy is the energy of motion (E = ½mv²).',
      category: 'energy',
      funFact:
          'When the bird flaps, it uses chemical energy from its muscles!',
    ),
    PhysicsFact(
      title: 'Potential Energy',
      description:
          'Potential energy is stored energy due to position. Higher = more potential energy.',
      category: 'energy',
      funFact:
          'A bird flying high has more gravitational potential energy than one flying low!',
    ),
    PhysicsFact(
      title: 'Friction & Air Resistance',
      description:
          'Air resistance opposes motion through air. It\'s why falling objects don\'t accelerate forever.',
      category: 'forces',
      funFact:
          'Air resistance is why feathers fall differently than rocks!',
    ),
    PhysicsFact(
      title: 'Centripetal Force',
      description:
          'The force needed to keep an object moving in a circle, always pointing toward the center.',
      category: 'forces',
      funFact:
          'When you swing something in a circle, you\'re providing centripetal force!',
    ),
    PhysicsFact(
      title: 'Impulse',
      description:
          'Impulse is force applied over time (I = F × t). A small force over long time = big impulse.',
      category: 'forces',
      funFact:
          'The bird\'s flap is an impulse that changes its momentum!',
    ),
    PhysicsFact(
      title: 'Free Fall',
      description:
          'Free fall is when an object moves only under gravity\'s influence, with no air resistance.',
      category: 'gravity',
      funFact:
          'In the game, the bird is in free fall when not flapping - it\'s pure physics!',
    ),
    PhysicsFact(
      title: 'Reaction Time & Physics',
      description:
          'The time it takes for your brain to react and move affects game physics - faster reactions mean better control!',
      category: 'motion',
      funFact:
          'Professional Flappy Bird players develop incredible reaction times!',
    ),
    PhysicsFact(
      title: 'Vector Addition',
      description:
          'Vectors have direction and magnitude. The bird\'s total velocity is the sum of gravity and flap forces.',
      category: 'forces',
      funFact:
          'Each flap adds an upward velocity vector to the bird\'s motion!',
    ),
  ];

  /// Get a random physics fact
  static PhysicsFact getRandomFact() {
    return facts[_random.nextInt(facts.length)];
  }

  /// Get a random fact from a specific category
  static PhysicsFact getRandomFactByCategory(String category) {
    final categoryFacts = facts.where((f) => f.category == category).toList();
    if (categoryFacts.isEmpty) return getRandomFact();
    return categoryFacts[_random.nextInt(categoryFacts.length)];
  }

  /// Get fact by index
  static PhysicsFact getFactByIndex(int index) {
    return facts[index % facts.length];
  }

  /// Get all categories
  static Set<String> getAllCategories() {
    return facts.map((f) => f.category).toSet();
  }

  /// Get all facts from a specific category
  static List<PhysicsFact> getFactsByCategory(String category) {
    return facts.where((f) => f.category == category).toList();
  }
}
