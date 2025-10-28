import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  final AudioPlayer _flapPlayer = AudioPlayer();
  final AudioPlayer _scorePlayer = AudioPlayer();
  final AudioPlayer _hitPlayer = AudioPlayer();
  final AudioPlayer _buttonPlayer = AudioPlayer();
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
      playSplashMusic();
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
      await _buttonPlayer.setReleaseMode(ReleaseMode.stop);
      
      // Set background music to loop
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.15); // Lower volume for background music
      
      // Set volumes for sound effects
      await _flapPlayer.setVolume(0.4); // Woosh sound
      await _scorePlayer.setVolume(0.5); // Coin received sound
      await _hitPlayer.setVolume(0.6); // Lose sound
      await _buttonPlayer.setVolume(0.5); // Button click sound
      
      _initialized = true;
    } catch (e) {
      // If audio initialization fails, continue without sound
      print('Sound initialization failed: $e');
    }
  }

  // Play Peppy Pals music on splash/menu screens
  Future<void> playSplashMusic() async {
    if (!_musicEnabled || !_initialized) return;
    try {
      await _musicPlayer.stop();
      await _musicPlayer.play(AssetSource(
        'audio/peppy-pals-just-playin-317068.mp3'
      ));
    } catch (e) {
      print('Error playing splash music: $e');
    }
  }

  // Play Ukulele music during gameplay
  Future<void> playGameMusic() async {
    if (!_musicEnabled || !_initialized) return;
    try {
      await _musicPlayer.stop();
      await _musicPlayer.play(AssetSource(
        'audio/ukulele-ukulele-joyful-cute-music-345390.mp3'
      ));
    } catch (e) {
      print('Error playing game music: $e');
    }
  }

  // Legacy method for backward compatibility
  Future<void> playBackgroundMusic() async {
    await playSplashMusic();
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

  // Woosh sound when tapping/flapping
  Future<void> playFlap() async {
    if (!_soundEnabled || !_initialized) return;
    try {
      await _flapPlayer.stop();
      await _flapPlayer.play(AssetSource(
        'audio/sfx/woosh-230554.mp3'
      ));
    } catch (e) {
      print('Error playing flap sound: $e');
    }
  }

  // Coin received sound when passing a pipe
  Future<void> playScore() async {
    if (!_soundEnabled || !_initialized) return;
    try {
      await _scorePlayer.stop();
      await _scorePlayer.play(AssetSource(
        'audio/sfx/coin-recieved-230517.mp3'
      ));
    } catch (e) {
      print('Error playing score sound: $e');
    }
  }

  // Lose sound when hitting obstacle
  Future<void> playHit() async {
    if (!_soundEnabled || !_initialized) return;
    try {
      await _hitPlayer.stop();
      await _hitPlayer.play(AssetSource(
        'audio/sfx/lose-sfx-365579.mp3'
      ));
    } catch (e) {
      print('Error playing hit sound: $e');
    }
  }

  // Button click sound for UI interactions
  Future<void> playButton() async {
    if (!_soundEnabled || !_initialized) return;
    try {
      await _buttonPlayer.stop();
      await _buttonPlayer.play(AssetSource(
        'audio/sfx/button-394464.mp3'
      ));
    } catch (e) {
      print('Error playing button sound: $e');
    }
  }

  // Achievement sound (reuse coin sound for now)
  Future<void> playAchievement() async {
    if (!_soundEnabled || !_initialized) return;
    try {
      await _scorePlayer.stop();
      await _scorePlayer.play(AssetSource(
        'audio/sfx/coin-recieved-230517.mp3'
      ));
    } catch (e) {
      print('Error playing achievement sound: $e');
    }
  }

  void dispose() {
    _flapPlayer.dispose();
    _scorePlayer.dispose();
    _hitPlayer.dispose();
    _buttonPlayer.dispose();
    _musicPlayer.dispose();
  }
}
