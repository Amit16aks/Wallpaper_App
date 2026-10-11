import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioHelper {
  static final AudioPlayer _player = AudioPlayer();
  static bool isBellSoundEnabled = true;

  /// Plays the authentic sacred brass temple bell chime
  static Future<void> playTempleBell() async {
    if (!isBellSoundEnabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/temple_bell.wav'), volume: 1.0);
    } catch (e) {
      debugPrint('Temple bell sound playback notice: $e');
    }
  }
}
