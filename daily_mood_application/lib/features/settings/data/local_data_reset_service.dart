import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/database/app_database.dart';
import '../../../core/security/db_key_manager.dart';

abstract interface class DatabaseKeyResetter {
  Future<void> rotateOpenDatabaseKey(AppDatabase database);
}

abstract interface class LocalDataResetService {
  Future<void> deleteAllData();
}

abstract interface class LocalMediaResetter {
  Future<void> deleteMoodMedia();
}

class SqlCipherDatabaseKeyResetter implements DatabaseKeyResetter {
  @override
  Future<void> rotateOpenDatabaseKey(AppDatabase database) async {
    final replacementKey = DbKeyManager.generateReplacementKey();
    await database.rekey(replacementKey);
    await DbKeyManager.storeReplacementKey(replacementKey);
  }
}

class AppDocumentLocalMediaResetter implements LocalMediaResetter {
  @override
  Future<void> deleteMoodMedia() async {
    final documents = await getApplicationDocumentsDirectory();
    for (final folderName in ['mood_photos', 'mood_voices']) {
      final directory = Directory(p.join(documents.path, folderName));
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    }
  }
}

class DriftLocalDataResetService implements LocalDataResetService {
  DriftLocalDataResetService({
    required AppDatabase database,
    DatabaseKeyResetter? keyResetter,
    LocalMediaResetter? mediaResetter,
  }) : _database = database,
       _keyResetter = keyResetter ?? SqlCipherDatabaseKeyResetter(),
       _mediaResetter = mediaResetter ?? AppDocumentLocalMediaResetter();

  final AppDatabase _database;
  final DatabaseKeyResetter _keyResetter;
  final LocalMediaResetter _mediaResetter;

  @override
  Future<void> deleteAllData() async {
    await _database.deleteAllLocalData();
    await _mediaResetter.deleteMoodMedia();
    await _keyResetter.rotateOpenDatabaseKey(_database);
  }
}
