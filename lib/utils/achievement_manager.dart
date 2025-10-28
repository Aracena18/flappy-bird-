import 'package:shared_preferences/shared_preferences.dart';

import '../models/achievement.dart';

class AchievementManager {
  static final AchievementManager _instance = AchievementManager._internal();
  factory AchievementManager() => _instance;
  AchievementManager._internal();

  List<Achievement> achievements = Achievement.getAll();
  Map<String, int> environmentScores = {};
  Map<String, int> environmentAttempts = {};
  int totalGamesPlayed = 0;
  Set<String> environmentsPlayed = {};

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load unlocked achievements
    for (var achievement in achievements) {
      achievement.isUnlocked = prefs.getBool('achievement_${achievement.id}') ?? false;
    }
    
    // Load stats
    totalGamesPlayed = prefs.getInt('total_games') ?? 0;
    
    // Load environment scores
    for (var mapId in ['space', 'moon', 'mars', 'venus', 'earth', 'saturn', 'neptune', 'jupiter']) {
      environmentScores[mapId] = prefs.getInt('best_score_$mapId') ?? 0;
      environmentAttempts[mapId] = prefs.getInt('attempts_$mapId') ?? 0;
      if (prefs.getBool('played_$mapId') ?? false) {
        environmentsPlayed.add(mapId);
      }
    }
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save unlocked achievements
    for (var achievement in achievements) {
      await prefs.setBool('achievement_${achievement.id}', achievement.isUnlocked);
    }
    
    // Save stats
    await prefs.setInt('total_games', totalGamesPlayed);
    
    // Save environment data
    for (var entry in environmentScores.entries) {
      await prefs.setInt('best_score_${entry.key}', entry.value);
    }
    for (var entry in environmentAttempts.entries) {
      await prefs.setInt('attempts_${entry.key}', entry.value);
    }
    for (var mapId in environmentsPlayed) {
      await prefs.setBool('played_$mapId', true);
    }
  }

  List<Achievement> checkAchievements(String mapId, int score, bool usedPause) {
    List<Achievement> newlyUnlocked = [];
    
    // Update stats
    totalGamesPlayed++;
    environmentsPlayed.add(mapId);
    environmentAttempts[mapId] = (environmentAttempts[mapId] ?? 0) + 1;
    
    // Update best score
    if (score > (environmentScores[mapId] ?? 0)) {
      environmentScores[mapId] = score;
    }
    
    // Check each achievement
    for (var achievement in achievements) {
      if (achievement.isUnlocked) continue;
      
      bool shouldUnlock = false;
      
      switch (achievement.id) {
        case 'first_flight':
          shouldUnlock = score >= 10;
          break;
          
        case 'gravity_rookie':
          shouldUnlock = environmentsPlayed.length >= 8;
          break;
          
        case 'quarter_century':
          shouldUnlock = score >= 25;
          break;
          
        case 'half_century':
          shouldUnlock = score >= 50;
          break;
          
        case 'century_club':
          shouldUnlock = score >= 100;
          break;
          
        case 'space_explorer':
          shouldUnlock = mapId == 'space' && score >= 30;
          break;
          
        case 'lunar_landing':
          shouldUnlock = mapId == 'moon' && score >= 25;
          break;
          
        case 'mars_colonist':
          shouldUnlock = mapId == 'mars' && score >= 20;
          break;
          
        case 'earth_master':
          shouldUnlock = mapId == 'earth' && score >= 30;
          break;
          
        case 'jupiter_survivor':
          shouldUnlock = mapId == 'jupiter' && score >= 10;
          break;
          
        case 'gravity_master':
          shouldUnlock = environmentScores.values.where((s) => s >= 20).length >= 8;
          break;
          
        case 'physics_professor':
          shouldUnlock = environmentScores.values.where((s) => s >= 50).length >= 5;
          break;
          
        case 'perfect_flight':
          shouldUnlock = score >= 50 && !usedPause;
          break;
      }
      
      if (shouldUnlock) {
        achievement.isUnlocked = true;
        newlyUnlocked.add(achievement);
      }
    }
    
    saveProgress();
    return newlyUnlocked;
  }

  int getUnlockedCount() {
    return achievements.where((a) => a.isUnlocked).length;
  }

  int getTotalCount() {
    return achievements.length;
  }
}
