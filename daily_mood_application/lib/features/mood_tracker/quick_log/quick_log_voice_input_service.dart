import 'dart:async';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class QuickLogVoiceInputService {
  QuickLogVoiceInputService({SpeechToText? speechToText})
    : _speechToText = speechToText ?? SpeechToText();

  static const maxListenDuration = Duration(minutes: 3);
  static const pauseDuration = Duration(seconds: 3);

  final SpeechToText _speechToText;

  Future<String?> listenForText() async {
    final completer = Completer<String?>();
    var latestText = '';
    var didStartListening = false;

    Future<void> complete(String? text) async {
      if (completer.isCompleted) return;
      final trimmed = text?.trim();
      await _speechToText.stop();
      completer.complete(trimmed == null || trimmed.isEmpty ? null : trimmed);
    }

    try {
      final available = await _speechToText.initialize(
        onError: (SpeechRecognitionError error) {
          if (!error.permanent) return;
          complete(latestText);
        },
        onStatus: (status) {
          if (didStartListening &&
              (status == 'done' || status == 'notListening')) {
            complete(latestText);
          }
        },
        options: [SpeechToText.androidNoBluetooth, SpeechToText.iosNoBluetooth],
      );
      if (!available) return null;

      didStartListening = true;
      await _speechToText.listen(
        onResult: (SpeechRecognitionResult result) {
          latestText = result.recognizedWords;
          if (result.finalResult) {
            complete(latestText);
          }
        },
        listenOptions: SpeechListenOptions(
          listenFor: maxListenDuration,
          pauseFor: pauseDuration,
          cancelOnError: false,
          partialResults: true,
        ),
      );
    } catch (_) {
      await _speechToText.stop();
      return null;
    }

    return completer.future.timeout(
      maxListenDuration + const Duration(seconds: 1),
      onTimeout: () {
        _speechToText.stop();
        return latestText.trim().isEmpty ? null : latestText.trim();
      },
    );
  }
}
