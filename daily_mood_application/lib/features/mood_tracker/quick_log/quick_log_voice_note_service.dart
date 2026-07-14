import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class QuickLogVoiceNoteService {
  QuickLogVoiceNoteService({AudioRecorder? recorder, Uuid uuid = const Uuid()})
    : _recorder = recorder ?? AudioRecorder(),
      _uuid = uuid;

  static const maxRecordDuration = Duration(minutes: 3);

  final AudioRecorder _recorder;
  final Uuid _uuid;

  String? _activeRelativePath;

  Future<bool> startRecording() async {
    try {
      if (await _recorder.isRecording()) return true;
      if (!await _recorder.hasPermission()) return false;

      final documents = await getApplicationDocumentsDirectory();
      final targetDirectory = Directory(p.join(documents.path, 'mood_voices'));
      await targetDirectory.create(recursive: true);

      final fileName = '${_uuid.v4()}.m4a';
      final targetPath = p.join(targetDirectory.path, fileName);
      _activeRelativePath = p
          .join('mood_voices', fileName)
          .replaceAll('\\', '/');

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 64000,
          sampleRate: 44100,
        ),
        path: targetPath,
      );

      return true;
    } on MissingPluginException {
      _activeRelativePath = null;
      return false;
    }
  }

  Future<String?> stopRecording() async {
    try {
      final relativePath = _activeRelativePath;
      final absolutePath = await _recorder.stop();
      _activeRelativePath = null;

      if (absolutePath == null || relativePath == null) return null;
      return relativePath;
    } on MissingPluginException {
      _activeRelativePath = null;
      return null;
    }
  }

  Future<void> cancelRecording() async {
    _activeRelativePath = null;
    try {
      await _recorder.cancel();
    } on MissingPluginException {
      return;
    }
  }

  Future<void> dispose() {
    try {
      return _recorder.dispose();
    } on MissingPluginException {
      return Future.value();
    }
  }
}
