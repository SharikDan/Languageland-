// Аудио-сервис для фоновой музыки и UI-звуков
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  AudioService._();

  static final AudioService _instance = AudioService._();
  static AudioService get instance => _instance;

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isMusicEnabled = true;
  bool _isSoundEnabled = true;
  bool _isMusicPlaying = false;
  String? _currentMusicPath;

  Future<void> initialize() async {
    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.3);
      await _sfxPlayer.setVolume(0.7);
      debugPrint('AudioService initialized');
    } catch (e) {
      debugPrint('AudioService init error: $e');
    }
  }

  Future<void> playMusic(String assetPath) async {
    if (!_isMusicEnabled) return;
    if (_currentMusicPath == assetPath && _isMusicPlaying) return;

    try {
      await _musicPlayer.stop();
      await _musicPlayer.play(AssetSource(assetPath));
      _isMusicPlaying = true;
      _currentMusicPath = assetPath;
    } catch (e) {
      debugPrint('Music play error: $e');
      _isMusicPlaying = false;
    }
  }

  Future<void> stopMusic() async {
    try {
      await _musicPlayer.stop();
      _isMusicPlaying = false;
      _currentMusicPath = null;
    } catch (e) {
      debugPrint('Music stop error: $e');
    }
  }

  Future<void> pauseMusic() async {
    try {
      await _musicPlayer.pause();
      _isMusicPlaying = false;
    } catch (e) {
      debugPrint('Music pause error: $e');
    }
  }

  Future<void> resumeMusic() async {
    if (!_isMusicEnabled) return;

    try {
      await _musicPlayer.resume();
      _isMusicPlaying = true;
    } catch (e) {
      debugPrint('Music resume error: $e');
    }
  }

  Future<void> playSound(String assetPath) async {
    if (!_isSoundEnabled) return;

    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint('Sound play error: $e');
    }
  }

  void setMusicEnabled(bool enabled) {
    _isMusicEnabled = enabled;
    if (!enabled && _isMusicPlaying) {
      stopMusic();
    } else if (enabled && !_isMusicPlaying) {
      playMusic('music/main_menu.mp3');
    }
  }

  void setSoundEnabled(bool enabled) {
    _isSoundEnabled = enabled;
  }

  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSoundEnabled => _isSoundEnabled;

  void dispose() {
    _musicPlayer.dispose();
    _sfxPlayer.dispose();
  }
}