import 'dart:convert';

import 'package:daily_mood_application/features/settings/data/backup_import_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const parser = BackupImportParser();

  test('parses valid JSON backup into typed records', () {
    final backup = parser.parseJson(
      jsonEncode({
        'exportVersion': 1,
        'schemaVersion': 2,
        'exportedAt': '2026-07-13T09:30:05.000Z',
        'mediaPackaging': 'embedded_base64',
        'mediaFiles': [
          {
            'relativePath': 'mood_photos/photo-1.jpg',
            'contentBase64': base64Encode([1, 2, 3, 4]),
          },
        ],
        'activities': [
          {
            'uuid': 'activity-1',
            'name': 'Reading',
            'category': 'Other',
            'isCustom': true,
            'isArchived': false,
            'createdAt': '2026-07-13T09:00:00.000Z',
          },
        ],
        'subEmotions': [
          {
            'name': 'Calm',
            'emoji': 'smiling-face-with-halo',
            'parentMoodScore': 4,
          },
        ],
        'moodEntries': [
          {
            'uuid': 'entry-1',
            'moodScore': 4,
            'note': 'Quiet morning',
            'voiceNotePath': null,
            'photoRelativePath': 'mood_photos/photo-1.jpg',
            'activityUuids': ['activity-1'],
            'activities': ['Reading'],
            'subEmotions': ['Calm'],
            'createdAt': '2026-07-13T09:15:00.000Z',
            'updatedAt': '2026-07-13T09:20:00.000Z',
            'isDeleted': false,
          },
        ],
      }),
    );

    expect(backup.exportVersion, 1);
    expect(backup.schemaVersion, 2);
    expect(backup.exportedAt, DateTime.utc(2026, 7, 13, 9, 30, 5));
    expect(backup.mediaPackaging, 'embedded_base64');
    expect(backup.mediaFiles.single.relativePath, 'mood_photos/photo-1.jpg');
    expect(backup.mediaFiles.single.bytes, [1, 2, 3, 4]);
    expect(backup.activities.single.name, 'Reading');
    expect(backup.subEmotions.single.name, 'Calm');
    expect(backup.entries.single.uuid, 'entry-1');
    expect(backup.entries.single.moodScore, 4);
    expect(backup.entries.single.photoRelativePath, 'mood_photos/photo-1.jpg');
    expect(backup.entries.single.activityUuids, ['activity-1']);
  });

  test('parses valid CSV backup with escaped text', () {
    final backup = parser.parseCsv(
      [
        '"uuid","moodScore","note","voiceNotePath","photoRelativePath",'
            '"activities","subEmotions","createdAt","updatedAt","isDeleted"',
        '"entry-1","5","Lunch, ""great""","","","Friends; Food",'
            '"Excited","2026-07-13T10:00:00.000Z",'
            '"2026-07-13T10:05:00.000Z","false"',
      ].join('\n'),
    );

    final entry = backup.entries.single;
    expect(entry.uuid, 'entry-1');
    expect(entry.moodScore, 5);
    expect(entry.note, 'Lunch, "great"');
    expect(entry.activityNames, ['Friends', 'Food']);
    expect(entry.subEmotionNames, ['Excited']);
    expect(entry.isDeleted, isFalse);
  });

  test('rejects corrupt JSON', () {
    expect(
      () => parser.parseJson('{bad json'),
      throwsA(isA<BackupImportParseException>()),
    );
  });

  test('rejects unsupported CSV header', () {
    expect(
      () => parser.parseCsv('"uuid","moodScore"\n"entry-1","4"'),
      throwsA(
        isA<BackupImportParseException>().having(
          (error) => error.message,
          'message',
          contains('header'),
        ),
      ),
    );
  });

  test('rejects invalid mood scores before import can mutate data', () {
    expect(
      () => parser.parseJson(
        jsonEncode({
          'exportVersion': 1,
          'schemaVersion': 2,
          'moodEntries': [
            {
              'uuid': 'entry-1',
              'moodScore': 6,
              'createdAt': '2026-07-13T10:00:00.000Z',
              'updatedAt': '2026-07-13T10:05:00.000Z',
            },
          ],
        }),
      ),
      throwsA(
        isA<BackupImportParseException>().having(
          (error) => error.message,
          'message',
          contains('between 1 and 5'),
        ),
      ),
    );
  });

  test('rejects absolute media paths', () {
    expect(
      () => parser.parseJson(
        jsonEncode({
          'exportVersion': 1,
          'schemaVersion': 2,
          'moodEntries': [
            {
              'uuid': 'entry-1',
              'moodScore': 4,
              'photoRelativePath': 'C:\\Users\\photo.jpg',
              'createdAt': '2026-07-13T10:00:00.000Z',
              'updatedAt': '2026-07-13T10:05:00.000Z',
            },
          ],
        }),
      ),
      throwsA(
        isA<BackupImportParseException>().having(
          (error) => error.message,
          'message',
          contains('relative path'),
        ),
      ),
    );
  });

  test('rejects packaged media outside mood media folders', () {
    expect(
      () => parser.parseJson(
        jsonEncode({
          'exportVersion': 1,
          'schemaVersion': 2,
          'mediaFiles': [
            {
              'relativePath': 'exports/photo.jpg',
              'contentBase64': base64Encode([1]),
            },
          ],
          'moodEntries': const [],
        }),
      ),
      throwsA(
        isA<BackupImportParseException>().having(
          (error) => error.message,
          'message',
          contains('mood media path'),
        ),
      ),
    );
  });

  test('rejects duplicate mood entry uuids', () {
    expect(
      () => parser.parseJson(
        jsonEncode({
          'exportVersion': 1,
          'schemaVersion': 2,
          'moodEntries': [
            {
              'uuid': 'entry-1',
              'moodScore': 4,
              'createdAt': '2026-07-13T10:00:00.000Z',
              'updatedAt': '2026-07-13T10:05:00.000Z',
            },
            {
              'uuid': 'entry-1',
              'moodScore': 3,
              'createdAt': '2026-07-14T10:00:00.000Z',
              'updatedAt': '2026-07-14T10:05:00.000Z',
            },
          ],
        }),
      ),
      throwsA(
        isA<BackupImportParseException>().having(
          (error) => error.message,
          'message',
          contains('duplicate'),
        ),
      ),
    );
  });
}
