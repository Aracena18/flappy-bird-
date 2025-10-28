import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  final AudioPlayer _flapPlayer = AudioPlayer();
  final AudioPlayer _scorePlayer = AudioPlayer();
  final AudioPlayer _hitPlayer = AudioPlayer();
  final AudioPlayer _achievementPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();

  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _initialized = false;

  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
  
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
  }

  void toggleMusic() {
    _musicEnabled = !_musicEnabled;
    if (_musicEnabled) {
      playBackgroundMusic();
    } else {
      stopBackgroundMusic();
    }
  }

  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      // Set up audio players
      await _flapPlayer.setReleaseMode(ReleaseMode.stop);
      await _scorePlayer.setReleaseMode(ReleaseMode.stop);
      await _hitPlayer.setReleaseMode(ReleaseMode.stop);
      await _achievementPlayer.setReleaseMode(ReleaseMode.stop);
      
      // Set background music to loop
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.15); // Lower volume for background music
      
      // Set volumes for sound effects
      await _flapPlayer.setVolume(0.3); // Subtle swoosh sound
      await _scorePlayer.setVolume(0.6);
      await _hitPlayer.setVolume(0.7);
      await _achievementPlayer.setVolume(0.8);
      
      _initialized = true;
    } catch (e) {
      // If audio initialization fails, continue without sound
      print('Sound initialization failed: $e');
    }
  }

  Future<void> playBackgroundMusic() async {
    if (!_musicEnabled || !_initialized) return;
    try {
      // Using local audio file - Peppy Pals music
      // Sweet and playful melody that loops continuously
      await _musicPlayer.play(AssetSource(
        'audio/peppy-pals-just-playin-317068.mp3'
      ));
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  Future<void> pauseBackgroundMusic() async {
    try {
      await _musicPlayer.pause();
    } catch (e) {
      print('Error pausing background music: $e');
    }
  }

  Future<void> resumeBackgroundMusic() async {
    if (!_musicEnabled || !_initialized) return;
    try {
      await _musicPlayer.resume();
    } catch (e) {
      print('Error resuming background music: $e');
    }
  }

  Future<void> stopBackgroundMusic() async {
    try {
      await _musicPlayer.stop();
    } catch (e) {
      print('Error stopping background music: $e');
    }
  }

  Future<void> playFlap() async {
    if (!_soundEnabled || !_initialized) return;
    try {
      // Subtle swoosh sound - not distracting
      await _flapPlayer.stop(); // Stop previous sound
      await _flapPlayer.play(UrlSource(
        'https://assets.mixkit.co/active_storage/sfx/2031/2031-preview.mp3'
      ));
    } catch (e) {
      print('Error playing flap sound: $e');
    }
  }

  Future<void> playScore() async {
    if (!_soundEnabled || !_initialized) return;
    try {
      // Positive ding/coin sound for scoring
      await _scorePlayer.stop();
      await _scorePlayer.play(UrlSource(
        'https://assets.mixkit.co/active_storage/sfx/2018/2018-preview.mp3'
      ));
    } catch (e) {
      print('Error playing score sound: $e');
    }
  }

  Future<void> playHit() async {
    if (!_soundEnabled || !_initialized) return;
    try {
      // Collision/hit sound effect
      await _hitPlayer.stop();
      await _hitPlayer.play(UrlSource(
        'https://assets.mixkit.co/active_storage/sfx/2004/2004-preview.mp3'
      ));
    } catch (e) {
      print('Error playing hit sound: $e');
    }
  }

  Future<void> playAchievement() async {
    if (!_soundEnabled || !_initialized) return;
    try {
      // Success/achievement fanfare sound
      await _achievementPlayer.stop();
      await _achievementPlayer.play(UrlSource(
        'https://assets.mixkit.co/active_storage/sfx/2000/2000-preview.mp3'
      ));
    } catch (e) {
      print('Error playing achievement sound: $e');
    }
  }

  void dispose() {
    _flapPlayer.dispose();
    _scorePlayer.dispose();
    _hitPlayer.dispose();
    _achievementPlayer.dispose();
    _musicPlayer.dispose();
  }
}

// Sound Effects Attribution:
// All sounds are from Pixabay (https://pixabay.com/sound-effects/)
// Licensed under the Pixabay License - Free for commercial and non-commercial use
// 
// Current sounds:
// - Background Music: Upbeat game music
// - Flap: Wing whoosh sound effect  
// - Score: Positive ding/coin collection sound
// - Hit: Collision/impact sound effect
// - Achievement: Success fanfare sound
//
// To use local audio files instead of URLs:
// 1. Download sound files and add them to assets/sounds/ directory
// 2. Update pubspec.yaml:
//    flutter:
//      assets:
//        - assets/sounds/
// 3. Replace UrlSource with AssetSource:
//    Example: await _flapPlayer.play(AssetSource('sounds/flap.mp3'));
