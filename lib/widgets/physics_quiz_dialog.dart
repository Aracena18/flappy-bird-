import 'package:flutter/material.dart';

import '../models/physics_quiz.dart';
import '../utils/sound_manager.dart';

class PhysicsQuizDialog extends StatefulWidget {
  final Function() onRevive;
  final Function() onGameEnd;
  final SoundManager soundManager;

  const PhysicsQuizDialog({
    super.key,
    required this.onRevive,
    required this.onGameEnd,
    required this.soundManager,
  });

  @override
  State<PhysicsQuizDialog> createState() => _PhysicsQuizDialogState();
}

class _PhysicsQuizDialogState extends State<PhysicsQuizDialog>
    with SingleTickerProviderStateMixin {
  late PhysicsQuizQuestion question;
  int? selectedAnswerIndex;
  bool showResult = false;
  bool isCorrect = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    question = PhysicsQuiz.getRandomQuestion();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (showResult) return;

    setState(() {
      selectedAnswerIndex = index;
      isCorrect = index == question.correctAnswerIndex;
      showResult = true;
    });

    // Play sound based on result
    if (isCorrect) {
      widget.soundManager.playAchievement();
    } else {
      widget.soundManager.playHit();
    }
  }

  void _handleResult() {
    if (isCorrect) {
      widget.onRevive();
      Navigator.pop(context);
    } else {
      widget.onGameEnd();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2C3E50),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF3498DB),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              if (!showResult)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3498DB).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Color(0xFFF39C12),
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Physics Quiz - Revive Chance!',
                        style: TextStyle(
                          color: Color(0xFFF39C12),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_animationController.value * 0.1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isCorrect
                              ? const Color(0xFF27AE60).withOpacity(0.2)
                              : const Color(0xFFE74C3C).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isCorrect ? Icons.check_circle : Icons.cancel,
                              color: isCorrect
                                  ? const Color(0xFF27AE60)
                                  : const Color(0xFFE74C3C),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isCorrect ? 'Correct! You\'re revived!' : 'Wrong Answer',
                              style: TextStyle(
                                color: isCorrect
                                    ? const Color(0xFF27AE60)
                                    : const Color(0xFFE74C3C),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 20),

              // Question
              Text(
                question.question,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Answer Options
              ...List.generate(question.options.length, (index) {
                final isSelected = selectedAnswerIndex == index;
                final isCorrectAnswer = index == question.correctAnswerIndex;

                Color backgroundColor = Colors.transparent;
                Color borderColor = const Color(0xFF95A5A6);
                Color textColor = Colors.white;

                if (showResult) {
                  if (isCorrectAnswer) {
                    backgroundColor = const Color(0xFF27AE60).withOpacity(0.3);
                    borderColor = const Color(0xFF27AE60);
                    textColor = const Color(0xFF27AE60);
                  } else if (isSelected && !isCorrect) {
                    backgroundColor = const Color(0xFFE74C3C).withOpacity(0.3);
                    borderColor = const Color(0xFFE74C3C);
                    textColor = const Color(0xFFE74C3C);
                  }
                } else if (isSelected) {
                  backgroundColor = const Color(0xFF3498DB).withOpacity(0.3);
                  borderColor = const Color(0xFF3498DB);
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: showResult ? null : () => _selectAnswer(index),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(
                            color: borderColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: textColor,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index), // A, B, C, D
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                question.options[index],
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (showResult && isCorrectAnswer)
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF27AE60),
                                size: 24,
                              )
                            else if (showResult && isSelected && !isCorrect)
                              Icon(
                                Icons.cancel,
                                color: const Color(0xFFE74C3C),
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // Explanation (shown after answer)
              if (showResult) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF95A5A6).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: Color(0xFF3498DB),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Explanation',
                            style: TextStyle(
                              color: Color(0xFF3498DB),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.explanation,
                        style: const TextStyle(
                          color: Color(0xFFECF0F1),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Action Button
              if (!showResult)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedAnswerIndex != null) {
                        _handleResult();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedAnswerIndex != null
                          ? const Color(0xFF3498DB)
                          : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: const Text(
                      'Submit Answer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleResult,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCorrect
                          ? const Color(0xFF27AE60)
                          : const Color(0xFFE74C3C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isCorrect ? 'Continue Playing' : 'End Game',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
