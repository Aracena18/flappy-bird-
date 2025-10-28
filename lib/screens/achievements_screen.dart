import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/achievement.dart';
import '../utils/achievement_manager.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final AchievementManager _achievementManager = AchievementManager();

  @override
  void initState() {
    super.initState();
    _achievementManager.loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    final unlockedCount = _achievementManager.getUnlockedCount();
    final totalCount = _achievementManager.getTotalCount();
    final progressPercent = (unlockedCount / totalCount * 100).toInt();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFFB6C1), // Pastel pink
              const Color(0xFFDDA0DD), // Plum
              const Color(0xFF9370DB), // Medium purple
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pink.withOpacity(0.5),
                                    blurRadius: 20,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [Color(0xFFFF69B4), Color(0xFFFFB6C1)],
                                ).createShader(bounds),
                                child: Text(
                                  'ACHIEVEMENTS',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48), // Balance for back button
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Progress Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '🏆 Progress',
                                style: GoogleFonts.fredoka(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF9370DB),
                                ),
                              ),
                              Text(
                                '$unlockedCount / $totalCount',
                                style: GoogleFonts.fredoka(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF69B4),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: LinearProgressIndicator(
                              value: unlockedCount / totalCount,
                              minHeight: 12,
                              backgroundColor: const Color(0xFFFFE4E1),
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF69B4)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$progressPercent% Complete',
                            style: GoogleFonts.bubblegumSans(
                              fontSize: 16,
                              color: const Color(0xFF9370DB),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Achievements List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _achievementManager.achievements.length,
                  itemBuilder: (context, index) {
                    final achievement = _achievementManager.achievements[index];
                    return _buildAchievementCard(achievement);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    final isUnlocked = achievement.isUnlocked;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: isUnlocked
            ? LinearGradient(
                colors: [
                  const Color(0xFFFFD700).withOpacity(0.9), // Gold
                  const Color(0xFFFFB6C1), // Pink
                ],
              )
            : LinearGradient(
                colors: [
                  Colors.grey.shade300,
                  Colors.grey.shade400,
                ],
              ),
        boxShadow: [
          BoxShadow(
            color: isUnlocked 
                ? Colors.yellow.withOpacity(0.4) 
                : Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: isUnlocked ? () {
            // Show achievement details
            _showAchievementDetails(achievement);
          } : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      isUnlocked ? achievement.icon : '🔒',
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isUnlocked ? achievement.title : '???',
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? Colors.white : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isUnlocked ? achievement.description : 'Locked - Keep playing to unlock!',
                        style: GoogleFonts.bubblegumSans(
                          fontSize: 14,
                          color: isUnlocked ? Colors.white.withOpacity(0.9) : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status indicator
                if (isUnlocked)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAchievementDetails(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFFD700), // Gold
                const Color(0xFFFFB6C1), // Pink
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.yellow.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                achievement.icon,
                style: const TextStyle(fontSize: 60),
              ),
              const SizedBox(height: 15),
              Text(
                'ACHIEVEMENT UNLOCKED!',
                style: GoogleFonts.fredoka(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                achievement.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                achievement.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.bubblegumSans(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFFF69B4),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Awesome!',
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
