import 'dart:math';

class PhysicsQuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  PhysicsQuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

class PhysicsQuiz {
  static final Random _random = Random();
  static final List<PhysicsQuizQuestion> questions = [
    PhysicsQuizQuestion(
      question: 'What happens to an object when gravity acts on it?',
      options: [
        'It moves upward',
        'It accelerates downward',
        'It stays in place',
        'It moves sideways',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Gravity causes objects to accelerate downward at 9.8 m/s² on Earth.',
    ),
    PhysicsQuizQuestion(
      question: 'What is the SI unit of acceleration?',
      options: [
        'm/s',
        'm/s²',
        'kg/m',
        'N/kg',
      ],
      correctAnswerIndex: 1,
      explanation: 'Acceleration is measured in meters per second squared (m/s²).',
    ),
    PhysicsQuizQuestion(
      question: 'If an object is falling, what does velocity do over time?',
      options: [
        'It decreases',
        'It stays the same',
        'It increases',
        'It becomes zero',
      ],
      correctAnswerIndex: 2,
      explanation: 'Under constant gravity, falling objects increase in velocity.',
    ),
    PhysicsQuizQuestion(
      question: 'What force pulls the bird downward in this game?',
      options: [
        'Air resistance',
        'Friction',
        'Gravity',
        'Thrust',
      ],
      correctAnswerIndex: 2,
      explanation: 'Gravity is the force that pulls all objects toward Earth.',
    ),
    PhysicsQuizQuestion(
      question: 'When you tap (flap) the screen, what direction does the bird move?',
      options: [
        'Downward',
        'Upward',
        'Left',
        'Right',
      ],
      correctAnswerIndex: 1,
      explanation: 'Flapping gives the bird an upward velocity to counteract gravity.',
    ),
    PhysicsQuizQuestion(
      question: 'What is the relationship between mass and gravitational force?',
      options: [
        'Force is inversely proportional to mass',
        'Force is directly proportional to mass',
        'Force has no relationship to mass',
        'Force decreases with mass',
      ],
      correctAnswerIndex: 1,
      explanation: 'Heavier objects experience more gravitational force (F = m × g).',
    ),
    PhysicsQuizQuestion(
      question: 'What does terminal velocity mean?',
      options: [
        'The velocity when an object stops',
        'The maximum velocity an object reaches while falling',
        'The initial velocity of an object',
        'The velocity needed to escape gravity',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Terminal velocity is the maximum speed reached when air resistance equals gravitational force.',
    ),
    PhysicsQuizQuestion(
      question: 'How does air resistance affect falling objects?',
      options: [
        'It increases their speed',
        'It decreases their acceleration',
        'It has no effect',
        'It reverses their direction',
      ],
      correctAnswerIndex: 1,
      explanation: 'Air resistance opposes motion and reduces acceleration.',
    ),
  ];

  /// Get a completely random question each time with shuffled answer options
  static PhysicsQuizQuestion getRandomQuestion() {
    // Get random question from the list
    final randomQuestion = questions[_random.nextInt(questions.length)];
    
    // Create a shuffled version of options with updated correct answer index
    final shuffledOptions = List<String>.from(randomQuestion.options);
    final originalCorrectAnswer = randomQuestion.options[randomQuestion.correctAnswerIndex];
    
    // Shuffle the options
    shuffledOptions.shuffle(_random);
    
    // Find new index of correct answer
    final newCorrectIndex = shuffledOptions.indexOf(originalCorrectAnswer);
    
    // Return new question with shuffled options
    return PhysicsQuizQuestion(
      question: randomQuestion.question,
      options: shuffledOptions,
      correctAnswerIndex: newCorrectIndex,
      explanation: randomQuestion.explanation,
    );
  }

  static PhysicsQuizQuestion getQuestionByIndex(int index) {
    return questions[index % questions.length];
  }
}
