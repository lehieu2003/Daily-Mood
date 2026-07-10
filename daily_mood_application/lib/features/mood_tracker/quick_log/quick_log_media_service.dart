import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class QuickLogMediaService {
  QuickLogMediaService({Uuid uuid = const Uuid()}) : _uuid = uuid;

  final Uuid _uuid;

  Future<String?> pickPhoto() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    final path = result?.files.single.path;
    if (path == null) return null;

    return _copyToAppStorage(
      sourcePath: path,
      directoryName: 'mood_photos',
      fallbackExtension: '.jpg',
    );
  }

  Future<String> _copyToAppStorage({
    required String sourcePath,
    required String directoryName,
    required String fallbackExtension,
  }) async {
    final source = File(sourcePath);
    final documents = await getApplicationDocumentsDirectory();
    final targetDirectory = Directory(p.join(documents.path, directoryName));
    await targetDirectory.create(recursive: true);

    final extension = p.extension(sourcePath).isEmpty
        ? fallbackExtension
        : p.extension(sourcePath);
    final fileName = '${_uuid.v4()}$extension';
    final target = File(p.join(targetDirectory.path, fileName));
    await source.copy(target.path);

    return p.join(directoryName, fileName).replaceAll('\\', '/');
  }
}
