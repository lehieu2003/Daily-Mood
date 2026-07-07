import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores and verifies the user's app-lock PIN.
///
/// This is intentionally separate from [DbKeyManager]: the PIN gates
/// the UI (can be changed/reset by the user), while the db encryption
/// key protects the data at rest and must never change silently.
class PinRepository {
  PinRepository({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  final FlutterSecureStorage _storage;

  static const _pinHashKey = 'app_lock_pin_hash_v1';
  static const _pinSaltKey = 'app_lock_pin_salt_v1';

  Future<bool> hasPinSet() async {
    final hash = await _storage.read(key: _pinHashKey);
    return hash != null && hash.isNotEmpty;
  }

  Future<void> setPin(String pin) async {
    _validatePinFormat(pin);
    final salt = _generateSalt();
    final hash = _hash(pin, salt);

    await _storage.write(key: _pinSaltKey, value: salt);
    await _storage.write(key: _pinHashKey, value: hash);
  }

  Future<bool> verifyPin(String pin) async {
    final storedHash = await _storage.read(key: _pinHashKey);
    final salt = await _storage.read(key: _pinSaltKey);
    if (storedHash == null || salt == null) return false;

    final candidateHash = _hash(pin, salt);
    return candidateHash == storedHash;
  }

  Future<void> clearPin() async {
    await _storage.delete(key: _pinHashKey);
    await _storage.delete(key: _pinSaltKey);
  }

  void _validatePinFormat(String pin) {
    if (pin.length != 4 && pin.length != 6) {
      throw ArgumentError('PIN must be 4 or 6 digits');
    }
    if (!RegExp(r'^\d+$').hasMatch(pin)) {
      throw ArgumentError('PIN must contain digits only');
    }
  }

  String _hash(String pin, String salt) {
    final bytes = utf8.encode('$salt:$pin');
    return sha256.convert(bytes).toString();
  }

  String _generateSalt({int byteLength = 16}) {
    final random = Random.secure();
    final bytes = List<int>.generate(byteLength, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
  }
}
