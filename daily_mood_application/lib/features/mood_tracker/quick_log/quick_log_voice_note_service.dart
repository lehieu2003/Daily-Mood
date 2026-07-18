import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

/// Provides the app documents directory used for local voice-note storage.
typedef VoiceDocumentsDirectoryProvider = Future<Directory> Function();

/// Boundary for the platform voice recorder used by quick-log voice notes.
abstract interface class QuickLogVoiceRecorder {
  /// Returns whether the recorder is actively recording.
  Future<bool> isRecording();

  /// Returns whether the app can record audio.
  Future<bool> hasPermission();

  /// Starts recording with [config] to [path].
  Future<void> start(RecordConfig config, {required String path});

  /// Stops the active recording and returns the recorded absolute file path.
  Future<String?> stop();

  /// Cancels the active recording without keeping the file.
  Future<void> cancel();

  /// Releases recorder resources.
  Future<void> dispose();
}

/// Records quick-log voice notes into app-managed local storage.
class QuickLogVoiceNoteService {
  /// Creates a voice-note service.
  QuickLogVoiceNoteService({
    AudioRecorder? recorder,
    QuickLogVoiceRecorder? voiceRecorder,
    VoiceDocumentsDirectoryProvider? documentsDirectoryProvider,
    Uuid uuid = const Uuid(),
    Duration recordDurationLimit = maxRecordDuration,
  }) : _recorder =
           voiceRecorder ?? _AudioRecorderAdapter(recorder ?? AudioRecorder()),
       _documentsDirectoryProvider =
           documentsDirectoryProvider ?? getApplicationDocumentsDirectory,
       _uuid = uuid,
       _maxRecordDuration = recordDurationLimit;

  /// Maximum duration for a quick-log voice note.
  static const maxRecordDuration = Duration(minutes: 3);

  /// Relative directory used for stored quick-log voice notes.
  static const voiceDirectoryName = 'mood_voices';

  final QuickLogVoiceRecorder _recorder;
  final VoiceDocumentsDirectoryProvider _documentsDirectoryProvider;
  final Uuid _uuid;
  final Duration _maxRecordDuration;

  String? _activeRelativePath;
  String? _activeAbsolutePath;
  Timer? _maxDurationTimer;

  /// Starts a voice-note recording.
  ///
  /// Returns `false` when recording cannot start because permission, platform,
  /// or storage setup failed.
  Future<bool> startRecording() async {
    try {
      if (await _recorder.isRecording()) {
        return _activeRelativePath != null;
      }
      if (!await _recorder.hasPermission()) return false;

      final target = await _createTarget();

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 64000,
          sampleRate: 44100,
        ),
        path: target.absolutePath,
      );
      _activeRelativePath = target.relativePath;
      _activeAbsolutePath = target.absolutePath;
      _startMaxDurationTimer();

      return true;
    } on Exception {
      _clearActiveRecording();
      return false;
    }
  }

  /// Stops the active recording and returns its relative storage path.
  ///
  /// Returns `null` when no usable recording file was produced.
  Future<String?> stopRecording() async {
    try {
      final relativePath = _activeRelativePath;
      final expectedAbsolutePath = _activeAbsolutePath;
      final absolutePath = await _recorder.stop();
      _clearActiveRecording();

      if (absolutePath == null ||
          relativePath == null ||
          expectedAbsolutePath == null) {
        return null;
      }
      if (!p.equals(absolutePath, expectedAbsolutePath)) return null;
      if (!await _recordingExists(expectedAbsolutePath)) return null;
      return relativePath;
    } on Exception {
      _clearActiveRecording();
      return null;
    }
  }

  /// Cancels the active recording and discards the pending relative path.
  Future<void> cancelRecording() async {
    _clearActiveRecording();
    try {
      await _recorder.cancel();
    } on Exception {
      return;
    }
  }

  /// Releases recorder resources and clears any active recording state.
  Future<void> dispose() async {
    _clearActiveRecording();
    try {
      await _recorder.dispose();
    } on Exception {
      return;
    }
  }

  Future<_VoiceNoteTarget> _createTarget() async {
    final documents = await _documentsDirectoryProvider();
    final targetDirectory = Directory(
      p.join(documents.path, voiceDirectoryName),
    );
    await targetDirectory.create(recursive: true);

    final fileName = '${_uuid.v4()}.m4a';
    return _VoiceNoteTarget(
      absolutePath: p.join(targetDirectory.path, fileName),
      relativePath: p.posix.join(voiceDirectoryName, fileName),
    );
  }

  Future<bool> _recordingExists(String absolutePath) async {
    final file = File(absolutePath);
    return await file.exists() && await file.length() > 0;
  }

  void _startMaxDurationTimer() {
    _maxDurationTimer?.cancel();
    _maxDurationTimer = Timer(_maxRecordDuration, () {
      unawaited(cancelRecording());
    });
  }

  void _clearActiveRecording() {
    _maxDurationTimer?.cancel();
    _maxDurationTimer = null;
    _activeRelativePath = null;
    _activeAbsolutePath = null;
  }
}

final class _VoiceNoteTarget {
  const _VoiceNoteTarget({
    required this.absolutePath,
    required this.relativePath,
  });

  final String absolutePath;
  final String relativePath;
}

final class _AudioRecorderAdapter implements QuickLogVoiceRecorder {
  _AudioRecorderAdapter(this._recorder);

  final AudioRecorder _recorder;

  @override
  Future<bool> isRecording() {
    return _recorder.isRecording();
  }

  @override
  Future<bool> hasPermission() {
    return _recorder.hasPermission();
  }

  @override
  Future<void> start(RecordConfig config, {required String path}) {
    return _recorder.start(config, path: path);
  }

  @override
  Future<String?> stop() {
    return _recorder.stop();
  }

  @override
  Future<void> cancel() {
    return _recorder.cancel();
  }

  @override
  Future<void> dispose() {
    return _recorder.dispose();
  }
}
