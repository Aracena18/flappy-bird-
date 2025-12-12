import 'dart:async';

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
  
  // Timer variables
  late Timer _countdownTimer;
  int _remainingSeconds = 15;

  @override
  void initState() {
    super.initState();
    question = PhysicsQuiz.getRandomQuestion();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    
    // Start countdown timer
    _startCountdownTimer();
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
      });
      
      // Time expired - auto-end game
      if (_remainingSeconds <= 0) {
        timer.cancel();
        if (!showResult && mounted) {
          // Auto-end game if time runs out without answering
          widget.soundManager.playHit();
          Navigator.pop(context);
          widget.onGameEnd();
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _countdownTimer.cancel();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 380;
    
    // Responsive sizing
    final dialogWidth = screenWidth > 900 ? screenWidth * 0.6 : screenWidth * 0.88;
    final dialogPadding = isSmallScreen ? 14.0 : 20.0;
    final spaceBetweenSections = isSmallScreen ? 12.0 : 16.0;
    final headerFontSize = isSmallScreen ? 13.0 : 15.0;
    final questionFontSize = isSmallScreen ? 15.0 : 17.0;
    final optionFontSize = isSmallScreen ? 13.0 : 15.0;
    final optionPadding = isSmallScreen ? 12.0 : 14.0;
    final buttonVerticalPadding = isSmallScreen ? 12.0 : 16.0;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
        ),
        child: Container(
          width: dialogWidth,
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.9,
          ),
          padding: EdgeInsets.all(dialogPadding),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with Timer
                if (!showResult)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 14,
                      vertical: isSmallScreen ? 10 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3498DB).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lightbulb,
                              color: const Color(0xFFF39C12),
                              size: isSmallScreen ? 20 : 24,
                            ),
                            SizedBox(width: isSmallScreen ? 6 : 8),
                            Flexible(
                              child: Text(
                                'Physics Quiz - Revive Chance!',
                                style: TextStyle(
                                  color: const Color(0xFFF39C12),
                                  fontSize: headerFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isSmallScreen ? 8 : 10),
                        // Timer
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 10 : 12,
                            vertical: isSmallScreen ? 5 : 6,
                          ),
                          decoration: BoxDecoration(
                            color: _remainingSeconds <= 5
                                ? const Color(0xFFE74C3C).withOpacity(0.8)
                                : const Color(0xFF27AE60).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer,
                                color: Colors.white,
                                size: isSmallScreen ? 16 : 18,
                              ),
                              SizedBox(width: isSmallScreen ? 3 : 4),
                              Text(
                                '$_remainingSeconds s',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 12 : 14,
                                ),
                              ),
                            ],
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
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 12 : 14,
                            vertical: isSmallScreen ? 10 : 12,
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
                                size: isSmallScreen ? 20 : 24,
                              ),
                              SizedBox(width: isSmallScreen ? 6 : 8),
                              Flexible(
                                child: Text(
                                  isCorrect ? 'Correct! You\'re revived!' : 'Wrong Answer',
                                  style: TextStyle(
                                    color: isCorrect
                                        ? const Color(0xFF27AE60)
                                        : const Color(0xFFE74C3C),
                                    fontSize: headerFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                SizedBox(height: spaceBetweenSections),

                // Question
                Text(
                  question.question,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: questionFontSize,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: spaceBetweenSections),

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
                    padding: EdgeInsets.only(bottom: isSmallScreen ? 10 : 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: showResult ? null : () => _selectAnswer(index),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: EdgeInsets.all(optionPadding),
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
                                width: isSmallScreen ? 24 : 28,
                                height: isSmallScreen ? 24 : 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: textColor,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + index),
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isSmallScreen ? 12 : 14,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: isSmallScreen ? 12 : 16),
                              Expanded(
                                child: Text(
                                  question.options[index],
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: optionFontSize,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (showResult && isCorrectAnswer)
                                Icon(
                                  Icons.check_circle,
                                  color: const Color(0xFF27AE60),
                                  size: isSmallScreen ? 20 : 24,
                                )
                              else if (showResult && isSelected && !isCorrect)
                                Icon(
                                  Icons.cancel,
                                  color: const Color(0xFFE74C3C),
                                  size: isSmallScreen ? 20 : 24,
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
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
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
                        Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: const Color(0xFF3498DB),
                              size: isSmallScreen ? 18 : 20,
                            ),
                            SizedBox(width: isSmallScreen ? 6 : 8),
                            Text(
                              'Explanation',
                              style: TextStyle(
                                color: const Color(0xFF3498DB),
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 13 : 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isSmallScreen ? 6 : 8),
                        Text(
                          question.explanation,
                          style: TextStyle(
                            color: const Color(0xFFECF0F1),
                            fontSize: isSmallScreen ? 13 : 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: spaceBetweenSections),

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
                        padding: EdgeInsets.symmetric(
                          vertical: buttonVerticalPadding,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: Text(
                        'Submit Answer',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
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
                        padding: EdgeInsets.symmetric(
                          vertical: buttonVerticalPadding,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isCorrect ? 'Continue Playing' : 'End Game',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
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
      ),
    );
  }
}
