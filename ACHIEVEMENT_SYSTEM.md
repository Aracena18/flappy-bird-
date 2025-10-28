# 🏆 Achievement System Guide

## Overview
Your Flappy Bird game now has a complete achievement system with **15 unique achievements** to unlock!

## How to Access Achievements
1. **From Map Selection Screen**: Tap the golden "🏆 Achievements" button in the top right
2. **View Progress**: See how many achievements you've unlocked (e.g., 5/15)
3. **Unlock Notifications**: When you game over, newly unlocked achievements will display in a golden card!

## Achievement Categories

### 🐣 Beginner Achievements
- **First Flight** - Score 10 points in any environment
- **Gravity Rookie** - Try all 8 gravity environments

### 🏅 Score Milestones
- **Quarter Century** - Score 25 points in any environment
- **Half Century** - Score 50 points in any environment  
- **Century Club** - Score 100 points in any environment

### 🌍 Environment-Specific Achievements
- **Space Explorer** 🌌 - Score 30+ in Space (lowest gravity)
- **Lunar Landing** 🌙 - Score 25+ on the Moon
- **Mars Colonist** 🔴 - Score 20+ on Mars
- **Earth Master** 🌍 - Score 30+ on Earth
- **Jupiter Survivor** 🟠 - Score 10+ on Jupiter (highest gravity!)

### 🎓 Master Achievements
- **Gravity Master** - Score 20+ on ALL environments
- **Physics Professor** - Score 50+ on 5 different environments
- **Perfect Flight** 💎 - Score 50+ without pausing

## Features

### Achievements Screen
- **Cute pink/purple gradient background**
- **Progress bar** showing completion percentage
- **Locked achievements** display as "🔒 ???" to create mystery
- **Unlocked achievements** show in golden gradient with full details
- **Tap unlocked achievements** to see celebration popup

### In-Game Integration
- **Automatic tracking** - Achievements check after every game
- **Sound effects** - Special achievement sound when unlocked
- **Game Over display** - Shows newly unlocked achievements in golden card
- **Persistent storage** - Progress saved using SharedPreferences

## Audio
- Achievement unlock plays a special celebration sound
- Background music at 15% volume for balance
- Tap/flap uses subtle swoosh sound (30% volume)

## UI Design
- 🎨 **Color scheme**: Gold (#FFD700) and Pink (#FFB6C1) gradients
- 🎯 **Fonts**: Fredoka for titles, Bubblegum Sans for descriptions
- ✨ **Animations**: Scale transitions, glow effects on achievement cards
- 💫 **Icons**: Emoji-based achievement icons for cuteness

## Tips for Players
1. Try **all 8 planets** to unlock "Gravity Rookie"
2. Master **low gravity** environments (Space, Moon) for easier high scores
3. Challenge yourself with **Jupiter's high gravity** for bragging rights
4. Don't pause during gameplay to unlock "Perfect Flight"
5. Keep playing to unlock all 15 achievements!

## Technical Details
- **Storage**: Uses `shared_preferences` package
- **Manager**: Singleton `AchievementManager` class
- **Models**: `Achievement` class with unlock logic
- **Screens**: Dedicated `AchievementsScreen` widget
- **Integration**: Automatic checking in `GameScreen`

Enjoy unlocking all achievements! 🎮🎉
