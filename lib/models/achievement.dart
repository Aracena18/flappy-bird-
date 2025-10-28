class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int targetScore;
  final String? mapId;
  bool isUnlocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.targetScore = 0,
    this.mapId,
    this.isUnlocked = false,
  });

  static List<Achievement> getAll() {
    return [
      // Beginner Achievements
      Achievement(
        id: 'first_flight',
        title: '🐣 First Flight',
        description: 'Score 10 points in any environment',
        icon: '🐣',
        targetScore: 10,
      ),
      Achievement(
        id: 'gravity_rookie',
        title: '🌟 Gravity Rookie',
        description: 'Try all 8 gravity environments',
        icon: '🌟',
      ),
      
      // Score Achievements
      Achievement(
        id: 'quarter_century',
        title: '🏅 Quarter Century',
        description: 'Score 25 points in any environment',
        icon: '🏅',
        targetScore: 25,
      ),
      Achievement(
        id: 'half_century',
        title: '🥈 Half Century',
        description: 'Score 50 points in any environment',
        icon: '🥈',
        targetScore: 50,
      ),
      Achievement(
        id: 'century_club',
        title: '🥇 Century Club',
        description: 'Score 100 points in any environment',
        icon: '🥇',
        targetScore: 100,
      ),
      
      // Environment-Specific
      Achievement(
        id: 'space_explorer',
        title: '🌌 Space Explorer',
        description: 'Score 30+ in Space (lowest gravity)',
        icon: '🌌',
        targetScore: 30,
        mapId: 'space',
      ),
      Achievement(
        id: 'lunar_landing',
        title: '🌙 Lunar Landing',
        description: 'Score 25+ on the Moon',
        icon: '🌙',
        targetScore: 25,
        mapId: 'moon',
      ),
      Achievement(
        id: 'mars_colonist',
        title: '🔴 Mars Colonist',
        description: 'Score 20+ on Mars',
        icon: '🔴',
        targetScore: 20,
        mapId: 'mars',
      ),
      Achievement(
        id: 'earth_master',
        title: '🌍 Earth Master',
        description: 'Score 30+ on Earth',
        icon: '🌍',
        targetScore: 30,
        mapId: 'earth',
      ),
      Achievement(
        id: 'jupiter_survivor',
        title: '🟠 Jupiter Survivor',
        description: 'Score 10+ on Jupiter (highest gravity!)',
        icon: '🟠',
        targetScore: 10,
        mapId: 'jupiter',
      ),
      
      // Master Achievements
      Achievement(
        id: 'gravity_master',
        title: '🎓 Gravity Master',
        description: 'Score 20+ on all environments',
        icon: '🎓',
      ),
      Achievement(
        id: 'physics_professor',
        title: '👨‍🏫 Physics Professor',
        description: 'Score 50+ on 5 different environments',
        icon: '👨‍🏫',
      ),
      Achievement(
        id: 'perfect_flight',
        title: '💎 Perfect Flight',
        description: 'Score 50+ without pausing',
        icon: '💎',
        targetScore: 50,
      ),
    ];
  }
}
