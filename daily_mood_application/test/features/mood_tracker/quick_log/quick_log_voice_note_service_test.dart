import 'dart:io';

import 'package:daily_mood_application/features/mood_tracker/quick_log/quick_log_voice_note_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:record/record.dart';

void main() {
  late Directory tempDirectory;
  late Directory documentsDirectory;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('quick_log_voice_');
    documentsDirectory = Directory(p.join(tempDirectory.path, 'documents'));
    await documentsDirectory.create();
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('stores a recording as an app-relative voice path', () async {
    final recorder = _FakeVoiceRecorder(writeFileOnStop: true);
    final service = QuickLogVoiceNoteService(
      voiceRecorder: recorder,
      documentsDirectoryProvider: () async => documentsDirectory,
    );

    final started = await service.startRecording();
    final relativePath = await service.stopRecording();

    expect(started, isTrue);
    expect(relativePath, isNotNull);
    expect(relativePath, startsWith('mood_voices/'));
    expect(relativePath, endsWith('.m4a'));
    expect(recorder.startedPath, isNotNull);
    expect(
      recorder.startedPath,
      p.joinAll([documentsDirectory.path, ...relativePath!.split('/')]),
    );
  });

  test('returns false when microphone permission is denied', () async {
    final recorder = _FakeVoiceRecorder(permissionGranted: false);
    final service = QuickLogVoiceNoteService(
      voiceRecorder: recorder,
      documentsDirectoryProvider: () async => documentsDirectory,
    );

    expect(await service.startRecording(), isFalse);
    expect(recorder.startCount, 0);
  });

  test('returns null when stopped recording file is missing', () async {
    final recorder = _FakeVoiceRecorder();
    final service = QuickLogVoiceNoteService(
      voiceRecorder: recorder,
      documentsDirectoryProvider: () async => documentsDirectory,
    );

    expect(await service.startRecording(), isTrue);
    expect(await service.stopRecording(), isNull);
  });

  test('normalizes recorder failures into false or null results', () async {
    final recorder = _FakeVoiceRecorder(throwOnStart: true);
    final service = QuickLogVoiceNoteService(
      voiceRecorder: recorder,
      documentsDirectoryProvider: () async => documentsDirectory,
    );

    expect(await service.startRecording(), isFalse);
    expect(await service.stopRecording(), isNull);
  });

  test('cancels active recordings after the duration limit', () async {
    final recorder = _FakeVoiceRecorder();
    final service = QuickLogVoiceNoteService(
      voiceRecorder: recorder,
      documentsDirectoryProvider: () async => documentsDirectory,
      recordDurationLimit: Duration.zero,
    );

    expect(await service.startRecording(), isTrue);
    await Future<void>.delayed(Duration.zero);

    expect(recorder.cancelCount, 1);
    expect(await service.stopRecording(), isNull);
  });
}

final class _FakeVoiceRecorder implements QuickLogVoiceRecorder {
  _FakeVoiceRecorder({
    this.permissionGranted = true,
    this.writeFileOnStop = false,
    this.throwOnStart = false,
  });

  final bool permissionGranted;
  final bool writeFileOnStop;
  final bool throwOnStart;

  String? startedPath;
  var startCount = 0;
  var cancelCount = 0;
  var _isRecording = false;

  @override
  Future<bool> isRecording() async => _isRecording;

  @override
  Future<bool> hasPermission() async => permissionGranted;

  @override
  Future<void> start(RecordConfig config, {required String path}) async {
    if (throwOnStart) {
      throw Exception('recorder failed');
    }

    startCount++;
    startedPath = path;
    _isRecording = true;
  }

  @override
  Future<String?> stop() async {
    _isRecording = false;
    final path = startedPath;
    if (path == null) return null;
    if (writeFileOnStop) {
      await File(path).writeAsBytes([1, 2, 3]);
    }
    return path;
  }

  @override
  Future<void> cancel() async {
    cancelCount++;
    _isRecording = false;
  }

  @override
  Future<void> dispose() async {}
}
