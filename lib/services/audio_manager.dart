import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

class AudioManager with WidgetsBindingObserver {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  // Audio players
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  // Settings
  bool _isBgmEnabled = true;
  bool _isSfxEnabled = true;
  double _bgmVolume = 0.7;
  double _sfxVolume = 0.8;

  // BGM tracks
  final String _loginBgm = 'audios/bgm/login.mp3';
  final List<String> _mainAppBgm = [
    'audios/bgm/track_1.mp3',
    'audios/bgm/track_2.mp3',
    'audios/bgm/track_3.mp3',
    'audios/bgm/track_10mins.mp3',
  ];

  // Volume normalization per track (adjust based on actual file loudness)
  final Map<String, double> _trackVolumeAdjustments = {
    'audios/bgm/login.mp3': 1.0,
    'audios/bgm/track_1.mp3': 1.0,
    'audios/bgm/track_2.mp3': 1.0,
    'audios/bgm/track_3.mp3': 1.0,
    'audios/bgm/track_10mins.mp3': 1.2, // Boost softer track
  };

  List<String> _shuffledPlaylist = [];
  int _currentTrackIndex = 0;
  bool _isLoginMode = true;
  bool _isFading = false;
  double _currentPlayingVolume = 0.0;
  bool _wasPlayingBeforePause = false;

  // Getters
  bool get isBgmEnabled => _isBgmEnabled;
  bool get isSfxEnabled => _isSfxEnabled;
  double get bgmVolume => _bgmVolume;
  double get sfxVolume => _sfxVolume;

  // Initialize audio manager
  Future<void> initialize() async {
    await _loadSettings();

    // Set audio context for better mobile playback
    await _bgmPlayer.setAudioContext(AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: {
          AVAudioSessionOptions.mixWithOthers,
        },
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: false,
        stayAwake: false,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.gain,
      ),
    ));

    await _sfxPlayer.setAudioContext(AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: {
          AVAudioSessionOptions.mixWithOthers,
        },
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: false,
        stayAwake: false,
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.gainTransientMayDuck,
      ),
    ));

    // Set volumes
    await _bgmPlayer.setVolume(_bgmVolume);
    await _sfxPlayer.setVolume(_sfxVolume);

    // Listen for track completion
    _bgmPlayer.onPlayerComplete.listen((event) {
      _onTrackComplete();
    });

    // Set release mode
    await _bgmPlayer.setReleaseMode(ReleaseMode.stop);
    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);

    // Register lifecycle observer
    WidgetsBinding.instance.addObserver(this);
  }

  // Handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // App going to background
        _wasPlayingBeforePause = _bgmPlayer.state == PlayerState.playing;
        if (_wasPlayingBeforePause) {
          pauseBgm();
        }
        break;
      case AppLifecycleState.resumed:
        // App returning to foreground
        if (_wasPlayingBeforePause && _isBgmEnabled) {
          resumeBgm();
        }
        break;
      case AppLifecycleState.detached:
        // App is detached
        break;
      case AppLifecycleState.hidden:
        // App is hidden (iOS/Android)
        break;
    }
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isBgmEnabled = prefs.getBool('bgm_enabled') ?? true;
    _isSfxEnabled = prefs.getBool('sfx_enabled') ?? true;
    _bgmVolume = prefs.getDouble('bgm_volume') ?? 0.7;
    _sfxVolume = prefs.getDouble('sfx_volume') ?? 0.8;
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('bgm_enabled', _isBgmEnabled);
    await prefs.setBool('sfx_enabled', _isSfxEnabled);
    await prefs.setDouble('bgm_volume', _bgmVolume);
    await prefs.setDouble('sfx_volume', _sfxVolume);
  }

  // Play login/walkthrough BGM
  Future<void> playLoginBgm() async {
    if (!_isBgmEnabled) return;

    // If already in login mode and playing, don't restart
    if (_isLoginMode && _bgmPlayer.state == PlayerState.playing) {
      return;
    }

    _isLoginMode = true;

    // Fade out current track if playing
    if (_bgmPlayer.state == PlayerState.playing) {
      await _fadeOut();
    }

    await _bgmPlayer.stop();
    await _bgmPlayer.play(AssetSource(_loginBgm));

    // Apply volume adjustment and fade in
    final adjustedVolume =
        _bgmVolume * (_trackVolumeAdjustments[_loginBgm] ?? 1.0);
    await _fadeIn(adjustedVolume);
  }

  // Play main app BGM (shuffled playlist)
  Future<void> playMainBgm() async {
    if (!_isBgmEnabled) return;

    // If already in main app mode and playing, don't restart
    if (!_isLoginMode && _bgmPlayer.state == PlayerState.playing) {
      return;
    }

    _isLoginMode = false;

    // Shuffle playlist on first play
    if (_shuffledPlaylist.isEmpty) {
      _shuffledPlaylist = List.from(_mainAppBgm);
      _shuffledPlaylist.shuffle(Random());
      _currentTrackIndex = 0;
    }

    // Fade out current track if playing
    if (_bgmPlayer.state == PlayerState.playing) {
      await _fadeOut();
    }

    await _bgmPlayer.stop();
    await _playCurrentTrack();
  }

  // Play current track in playlist
  Future<void> _playCurrentTrack() async {
    if (!_isBgmEnabled || _shuffledPlaylist.isEmpty) return;

    final track = _shuffledPlaylist[_currentTrackIndex];
    await _bgmPlayer.play(AssetSource(track));

    // Apply volume adjustment and fade in
    final adjustedVolume = _bgmVolume * (_trackVolumeAdjustments[track] ?? 1.0);
    await _fadeIn(adjustedVolume);
  }

  // Fade in effect
  Future<void> _fadeIn(double targetVolume) async {
    if (_isFading) return;
    _isFading = true;

    const steps = 30;
    const stepDuration = Duration(milliseconds: 50);

    for (int i = 0; i <= steps; i++) {
      if (!_isBgmEnabled || _bgmPlayer.state != PlayerState.playing) break;

      final volume = (i / steps) * targetVolume;
      await _bgmPlayer.setVolume(volume);
      await Future.delayed(stepDuration);
    }

    _currentPlayingVolume = targetVolume;
    _isFading = false;
  }

  // Fade out effect
  Future<void> _fadeOut() async {
    if (_isFading) return;
    _isFading = true;

    final currentVolume = _currentPlayingVolume;
    const steps = 20;
    const stepDuration = Duration(milliseconds: 50);

    for (int i = steps; i >= 0; i--) {
      if (_bgmPlayer.state != PlayerState.playing) break;

      final volume = (i / steps) * currentVolume;
      await _bgmPlayer.setVolume(volume);
      await Future.delayed(stepDuration);
    }

    _currentPlayingVolume = 0.0;
    _isFading = false;
  }

  // Handle track completion
  void _onTrackComplete() {
    if (_isLoginMode) {
      // Login track finished, loop it (will fade in again)
      playLoginBgm();
    } else {
      // Main app: advance to next track with crossfade
      _currentTrackIndex++;

      // Reshuffle when playlist ends
      if (_currentTrackIndex >= _shuffledPlaylist.length) {
        _shuffledPlaylist.shuffle(Random());
        _currentTrackIndex = 0;
      }

      // No fade out needed since track naturally ended
      _playCurrentTrack();
    }
  }

  // Stop BGM
  Future<void> stopBgm() async {
    await _bgmPlayer.stop();
  }

  // Pause BGM
  Future<void> pauseBgm() async {
    await _bgmPlayer.pause();
  }

  // Resume BGM
  Future<void> resumeBgm() async {
    await _bgmPlayer.resume();
  }

  // Play SFX
  Future<void> playSfx(String sfxName) async {
    if (!_isSfxEnabled) return;

    await _sfxPlayer.stop();
    await _sfxPlayer.setVolume(_sfxVolume);
    await _sfxPlayer.play(AssetSource('audios/sfx/$sfxName'));
  }

  // Toggle BGM on/off
  Future<void> toggleBgm(bool enabled) async {
    _isBgmEnabled = enabled;
    await _saveSettings();

    if (!enabled) {
      await stopBgm();
    } else {
      // Resume based on mode
      if (_isLoginMode) {
        await playLoginBgm();
      } else {
        await playMainBgm();
      }
    }
  }

  // Toggle SFX on/off
  Future<void> toggleSfx(bool enabled) async {
    _isSfxEnabled = enabled;
    await _saveSettings();
  }

  // Set BGM volume (0.0 - 1.0)
  Future<void> setBgmVolume(double volume) async {
    _bgmVolume = volume.clamp(0.0, 1.0);
    await _saveSettings();

    // Reapply volume with normalization to current track
    if (_bgmPlayer.state == PlayerState.playing) {
      String? currentTrack;
      if (_isLoginMode) {
        currentTrack = _loginBgm;
      } else if (_shuffledPlaylist.isNotEmpty) {
        currentTrack = _shuffledPlaylist[_currentTrackIndex];
      }

      if (currentTrack != null) {
        final adjustedVolume =
            _bgmVolume * (_trackVolumeAdjustments[currentTrack] ?? 1.0);
        await _bgmPlayer.setVolume(adjustedVolume);
      }
    }
  }

  // Set SFX volume (0.0 - 1.0)
  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);
    await _sfxPlayer.setVolume(_sfxVolume);
    await _saveSettings();
  }

  // Dispose players
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await _bgmPlayer.dispose();
    await _sfxPlayer.dispose();
  }
}
