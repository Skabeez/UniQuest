import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'settings_page_widget.dart' show SettingsPageWidget;
import 'package:flutter/material.dart';
import '/services/audio_manager.dart';

class SettingsPageModel extends FlutterFlowModel<SettingsPageWidget> {
  // State fields for audio settings
  late bool isBgmEnabled;
  late bool isSfxEnabled;
  late double bgmVolume;
  late double sfxVolume;

  @override
  void initState(BuildContext context) {
    // Initialize with current audio manager values
    isBgmEnabled = AudioManager().isBgmEnabled;
    isSfxEnabled = AudioManager().isSfxEnabled;
    bgmVolume = AudioManager().bgmVolume;
    sfxVolume = AudioManager().sfxVolume;
  }

  @override
  void dispose() {}
}
