import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Opens the platform image picker and returns the selected source path.
typedef PhotoPathPicker = Future<String?> Function();

/// Compresses a source photo into the requested target path.
typedef PhotoCompressor =
    Future<File?> Function({
      required String sourcePath,
      required String targetPath,
      required int maxLongEdge,
      required int quality,
    });

/// Provides the app documents directory used for local media storage.
typedef DocumentsDirectoryProvider = Future<Directory> Function();

/// Boundary for quick-log photo attachment operations.
abstract interface class QuickLogMediaGateway {
  /// Picks an image, stores it as a compressed JPEG, and returns its relative path.
  ///
  /// Returns `null` when the picker is cancelled. Throws
  /// [QuickLogPhotoException] when the source or stored image violates the size
  /// guard, or when compression fails.
  Future<String?> pickPhoto();

  /// Resolves a stored photo relative path to its file in app storage.
  ///
  /// The path must be a relative path under [QuickLogMediaService.photoDirectoryName].
  Future<File> resolvePhoto(String relativePath);

  /// Deletes a stored quick-log photo when it exists.
  ///
  /// The path must be a relative path under [QuickLogMediaService.photoDirectoryName].
  Future<void> deletePhoto(String relativePath);

  /// Returns whether a stored quick-log photo exists.
  ///
  /// The path must be a relative path under [QuickLogMediaService.photoDirectoryName].
  Future<bool> photoExists(String relativePath);
}

/// Stores and resolves quick-log photo attachments in app-managed storage.
class QuickLogMediaService implements QuickLogMediaGateway {
  /// Creates a media service for quick-log photo attachments.
  QuickLogMediaService({
    Uuid uuid = const Uuid(),
    PhotoPathPicker? pickImagePath,
    PhotoCompressor? compressPhoto,
    DocumentsDirectoryProvider? documentsDirectoryProvider,
    int maxSourcePhotoBytes = maxDefaultSourcePhotoBytes,
    int maxStoredPhotoBytes = maxDefaultStoredPhotoBytes,
  }) : _uuid = uuid,
       _pickImagePath = pickImagePath ?? _pickPhotoPath,
       _compressPhoto = compressPhoto ?? _compressPhotoToJpeg,
       _documentsDirectoryProvider =
           documentsDirectoryProvider ?? getApplicationDocumentsDirectory,
       _maxSourcePhotoBytes = maxSourcePhotoBytes,
       _maxStoredPhotoBytes = maxStoredPhotoBytes;

  /// Maximum long edge, in pixels, for stored quick-log photos.
  static const maxPhotoLongEdge = 1080;

  /// JPEG quality used when storing quick-log photos.
  static const photoQuality = 80;

  /// Default maximum size, in bytes, accepted from a picked source photo.
  static const maxDefaultSourcePhotoBytes = 20 * 1024 * 1024;

  /// Default maximum size, in bytes, allowed after compression.
  static const maxDefaultStoredPhotoBytes = 5 * 1024 * 1024;

  /// Relative directory used for stored quick-log photos.
  static const photoDirectoryName = 'mood_photos';

  final Uuid _uuid;
  final PhotoPathPicker _pickImagePath;
  final PhotoCompressor _compressPhoto;
  final DocumentsDirectoryProvider _documentsDirectoryProvider;
  final int _maxSourcePhotoBytes;
  final int _maxStoredPhotoBytes;

  /// Picks an image, stores it as a compressed JPEG, and returns its relative path.
  ///
  /// Returns `null` when the picker is cancelled. Throws
  /// [QuickLogPhotoException] when the source or stored image violates the size
  /// guard, or when compression fails.
  @override
  Future<String?> pickPhoto() async {
    final path = await _pickImagePath();
    if (path == null) return null;

    return _storePhoto(sourcePath: path);
  }

  /// Resolves a stored photo relative path to its file in app storage.
  ///
  /// The path must be a relative path under [photoDirectoryName].
  @override
  Future<File> resolvePhoto(String relativePath) async {
    final documents = await _documentsDirectoryProvider();
    final normalizedPath = _normalizePhotoRelativePath(relativePath);

    return File(p.joinAll([documents.path, ...p.posix.split(normalizedPath)]));
  }

  /// Deletes a stored quick-log photo when it exists.
  ///
  /// The path must be a relative path under [photoDirectoryName].
  @override
  Future<void> deletePhoto(String relativePath) async {
    final photo = await resolvePhoto(relativePath);
    if (await photo.exists()) {
      await photo.delete();
    }
  }

  /// Returns whether a stored quick-log photo exists.
  ///
  /// The path must be a relative path under [photoDirectoryName].
  @override
  Future<bool> photoExists(String relativePath) async {
    final photo = await resolvePhoto(relativePath);
    return photo.exists();
  }

  Future<String> _storePhoto({required String sourcePath}) async {
    await _validateSourcePhotoSize(sourcePath);

    final target = await _createPhotoTargetFile();
    final compressed = await _compressPickedPhoto(
      sourcePath: sourcePath,
      targetPath: target.path,
    );
    await _validateStoredPhotoSize(compressed);

    return _relativePhotoPath(target);
  }

  Future<void> _validateSourcePhotoSize(String sourcePath) async {
    final sourceSize = await File(sourcePath).length();
    if (sourceSize <= _maxSourcePhotoBytes) return;

    throw const QuickLogPhotoException(QuickLogPhotoError.tooLarge);
  }

  Future<File> _createPhotoTargetFile() async {
    final targetDirectory = await _photoDirectory();
    await targetDirectory.create(recursive: true);

    final fileName = '${_uuid.v4()}.jpg';
    return File(p.join(targetDirectory.path, fileName));
  }

  Future<Directory> _photoDirectory() async {
    final documents = await _documentsDirectoryProvider();
    return Directory(p.join(documents.path, photoDirectoryName));
  }

  Future<File> _compressPickedPhoto({
    required String sourcePath,
    required String targetPath,
  }) async {
    final compressed = await _compressPhoto(
      sourcePath: sourcePath,
      targetPath: targetPath,
      maxLongEdge: maxPhotoLongEdge,
      quality: photoQuality,
    );

    if (compressed != null && await compressed.exists()) {
      return compressed;
    }

    throw const QuickLogPhotoException(QuickLogPhotoError.processingFailed);
  }

  Future<void> _validateStoredPhotoSize(File photo) async {
    final storedSize = await photo.length();
    if (storedSize <= _maxStoredPhotoBytes) return;

    await photo.delete();
    throw const QuickLogPhotoException(QuickLogPhotoError.tooLarge);
  }

  String _relativePhotoPath(File target) {
    return p.posix.join(photoDirectoryName, p.basename(target.path));
  }

  String _normalizePhotoRelativePath(String relativePath) {
    final path = relativePath.replaceAll('\\', '/');
    final normalizedPath = p.posix.normalize(path);
    final segments = p.posix.split(normalizedPath);

    if (p.posix.isAbsolute(path) ||
        normalizedPath == '.' ||
        normalizedPath == '..' ||
        normalizedPath.startsWith('../') ||
        segments.length < 2 ||
        segments.first != photoDirectoryName) {
      throw ArgumentError.value(
        relativePath,
        'relativePath',
        'Must be a relative quick-log photo path under $photoDirectoryName.',
      );
    }

    return normalizedPath;
  }

  static Future<String?> _pickPhotoPath() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    return result?.files.single.path;
  }

  static Future<File?> _compressPhotoToJpeg({
    required String sourcePath,
    required String targetPath,
    required int maxLongEdge,
    required int quality,
  }) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      targetPath,
      minWidth: maxLongEdge,
      minHeight: maxLongEdge,
      quality: quality,
      format: CompressFormat.jpeg,
    );
    return result == null ? null : File(result.path);
  }
}

/// The category of quick-log photo failure.
enum QuickLogPhotoError {
  /// The source or compressed photo exceeds the configured size guard.
  tooLarge,

  /// The image compressor failed to produce a usable stored photo.
  processingFailed,
}

/// Exception thrown when quick-log photo picking or storage fails.
class QuickLogPhotoException implements Exception {
  /// Creates a photo exception for [error].
  const QuickLogPhotoException(this.error);

  /// The reason the photo operation failed.
  final QuickLogPhotoError error;
}
