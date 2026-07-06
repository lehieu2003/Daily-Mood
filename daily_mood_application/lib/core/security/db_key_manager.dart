import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Manages the SQLCipher database passphrase.
///
/// The key itself is generated once on first launch, then stored in
/// Android Keystore / iOS Keychain via flutter_secure_storage — never
/// hardcoded, never written to plaintext files, never logged.
class DbKeyManager {
  DbKeyManager._();

  static const _storage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _keyStorageKey = 'db_encryption_key_v1';

  /// Returns the existing passphrase, or generates + persists a new
  /// cryptographically random one on first run.
  static Future<String> getOrCreateKey() async {
    final existing = await _storage.read(key: _keyStorageKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final newKey = _generateSecureKey();
    await _storage.write(key: _keyStorageKey, value: newKey);
    return newKey;
  }

  static String _generateSecureKey({int byteLength = 32}) {
    final random = Random.secure();
    final bytes = List<int>.generate(byteLength, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  /// Only ever call this from an explicit, user-confirmed
  /// "delete all data" flow — losing this key makes the encrypted
  /// database permanently unreadable.
  static Future<void> deleteKey() async {
    await _storage.delete(key: _keyStorageKey);
  }
}
