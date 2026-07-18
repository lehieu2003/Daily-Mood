import 'dart:io';

import 'package:daily_mood_application/features/mood_tracker/quick_log/quick_log_media_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory tempDirectory;
  late Directory documentsDirectory;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('quick_log_media_');
    documentsDirectory = Directory(p.join(tempDirectory.path, 'documents'));
    await documentsDirectory.create();
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('implements the quick-log media gateway interface', () {
    final service = QuickLogMediaService(
      documentsDirectoryProvider: () async => documentsDirectory,
    );

    expect(service, isA<QuickLogMediaGateway>());
  });

  test(
    'compresses picked photo into app storage as a relative jpeg path',
    () async {
      final source = File(p.join(tempDirectory.path, 'source.png'));
      await source.writeAsBytes(List<int>.filled(1024, 1));

      String? compressorSourcePath;
      String? compressorTargetPath;
      int? compressorMaxLongEdge;
      int? compressorQuality;

      final service = QuickLogMediaService(
        pickImagePath: () async => source.path,
        documentsDirectoryProvider: () async => documentsDirectory,
        compressPhoto:
            ({
              required sourcePath,
              required targetPath,
              required maxLongEdge,
              required quality,
            }) async {
              compressorSourcePath = sourcePath;
              compressorTargetPath = targetPath;
              compressorMaxLongEdge = maxLongEdge;
              compressorQuality = quality;

              final target = File(targetPath);
              await target.writeAsBytes(List<int>.filled(512, 2));
              return target;
            },
      );

      final relativePath = await service.pickPhoto();

      expect(relativePath, isNotNull);
      expect(relativePath, startsWith('mood_photos/'));
      expect(relativePath, endsWith('.jpg'));
      expect(relativePath, isNot(contains('\\')));
      expect(compressorSourcePath, source.path);
      expect(
        compressorTargetPath,
        p.joinAll([documentsDirectory.path, ...relativePath!.split('/')]),
      );
      expect(compressorMaxLongEdge, QuickLogMediaService.maxPhotoLongEdge);
      expect(compressorQuality, QuickLogMediaService.photoQuality);
      expect(
        await File(
          p.joinAll([documentsDirectory.path, ...relativePath.split('/')]),
        ).readAsBytes(),
        List<int>.filled(512, 2),
      );
    },
  );

  test('returns null when the picker is canceled', () async {
    final service = QuickLogMediaService(
      pickImagePath: () async => null,
      documentsDirectoryProvider: () async => documentsDirectory,
      compressPhoto:
          ({
            required sourcePath,
            required targetPath,
            required maxLongEdge,
            required quality,
          }) async {
            fail('compressor should not run after picker cancellation');
          },
    );

    expect(await service.pickPhoto(), isNull);
  });

  test('rejects source photos above the source size guard', () async {
    final source = File(p.join(tempDirectory.path, 'source.jpg'));
    await source.writeAsBytes(List<int>.filled(8, 1));

    final service = QuickLogMediaService(
      pickImagePath: () async => source.path,
      documentsDirectoryProvider: () async => documentsDirectory,
      maxSourcePhotoBytes: 4,
      compressPhoto:
          ({
            required sourcePath,
            required targetPath,
            required maxLongEdge,
            required quality,
          }) async {
            fail('compressor should not run for oversized source photos');
          },
    );

    await expectLater(
      service.pickPhoto(),
      throwsA(
        isA<QuickLogPhotoException>().having(
          (error) => error.error,
          'error',
          QuickLogPhotoError.tooLarge,
        ),
      ),
    );
  });

  test(
    'deletes compressed output when it remains above the stored size guard',
    () async {
      final source = File(p.join(tempDirectory.path, 'source.jpg'));
      await source.writeAsBytes(List<int>.filled(8, 1));
      File? compressedFile;

      final service = QuickLogMediaService(
        pickImagePath: () async => source.path,
        documentsDirectoryProvider: () async => documentsDirectory,
        maxStoredPhotoBytes: 4,
        compressPhoto:
            ({
              required sourcePath,
              required targetPath,
              required maxLongEdge,
              required quality,
            }) async {
              compressedFile = File(targetPath);
              await compressedFile!.writeAsBytes(List<int>.filled(8, 2));
              return compressedFile;
            },
      );

      await expectLater(
        service.pickPhoto(),
        throwsA(
          isA<QuickLogPhotoException>().having(
            (error) => error.error,
            'error',
            QuickLogPhotoError.tooLarge,
          ),
        ),
      );
      expect(compressedFile, isNotNull);
      expect(await compressedFile!.exists(), isFalse);
    },
  );

  test('resolves stored photo relative paths inside app documents', () async {
    final service = QuickLogMediaService(
      documentsDirectoryProvider: () async => documentsDirectory,
    );

    final photo = await service.resolvePhoto('mood_photos/example.jpg');

    expect(
      photo.path,
      p.join(documentsDirectory.path, 'mood_photos', 'example.jpg'),
    );
  });

  test('checks whether a stored photo exists', () async {
    final service = QuickLogMediaService(
      documentsDirectoryProvider: () async => documentsDirectory,
    );
    final photoDirectory = Directory(
      p.join(documentsDirectory.path, 'mood_photos'),
    );
    await photoDirectory.create();
    await File(p.join(photoDirectory.path, 'existing.jpg')).writeAsBytes([1]);

    expect(await service.photoExists('mood_photos/existing.jpg'), isTrue);
    expect(await service.photoExists('mood_photos/missing.jpg'), isFalse);
  });

  test('deletes stored photos without failing when already missing', () async {
    final service = QuickLogMediaService(
      documentsDirectoryProvider: () async => documentsDirectory,
    );
    final photoDirectory = Directory(
      p.join(documentsDirectory.path, 'mood_photos'),
    );
    await photoDirectory.create();
    final photo = File(p.join(photoDirectory.path, 'delete-me.jpg'));
    await photo.writeAsBytes([1]);

    await service.deletePhoto('mood_photos/delete-me.jpg');
    await service.deletePhoto('mood_photos/delete-me.jpg');

    expect(await photo.exists(), isFalse);
  });

  test('rejects paths outside quick-log photo storage', () async {
    final service = QuickLogMediaService(
      documentsDirectoryProvider: () async => documentsDirectory,
    );

    await expectLater(
      service.resolvePhoto('../mood_photos/escape.jpg'),
      throwsArgumentError,
    );
    await expectLater(
      service.resolvePhoto('mood_photos/../database.sqlite'),
      throwsArgumentError,
    );
    await expectLater(
      service.resolvePhoto('voice_notes/example.m4a'),
      throwsArgumentError,
    );
  });
}
