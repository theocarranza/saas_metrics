import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saas_metrics/features/auth/domain/entities/auth_token.dart';
import 'package:saas_metrics/features/auth/data/models/auth_token_model.dart';

class AuthRepository {
  static const String _tokenKey = 'auth_token';
  static const Duration _sessionDuration = Duration(minutes: 10);

  // Generate a random token string (simulation)
  String _generateToken() {
    final random = Random();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  Future<AuthToken> login(String email, String password) async {
    // In a real app, we would validate credentials here.
    // For simulation, we just generate a token.
    final token = AuthTokenModel(
      value: _generateToken(),
      expiry: DateTime.now().add(_sessionDuration),
    );

    await _saveToken(token);
    return token;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    // Also remove legacy boolean if it exists
    await prefs.remove('signed_in');
  }

  Future<AuthToken?> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_tokenKey);

    if (jsonString == null) {
      return null;
    }

    try {
      // Use Model for deserialization
      final token = AuthTokenModel.fromJson(jsonString);
      if (token.isValid) {
        // Refresh session
        final newToken = AuthTokenModel(
          value: token.value, // Keep same token
          expiry: DateTime.now().add(_sessionDuration), // Extend expiry
        );
        await _saveToken(newToken);
        return newToken;
      } else {
        // Token expired
        await logout();
        return null;
      }
    } catch (e) {
      // Corrupt data
      await logout();
      return null;
    }
  }

  Future<void> _saveToken(AuthTokenModel token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token.toJson());
  }
}
