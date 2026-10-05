import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

enum SocialProvider {
  google('Google'),
  facebook('Facebook'),
  apple('Apple');

  const SocialProvider(this.label);
  final String label;
}

/// Local accounts stored on-device. Passwords are kept as salted SHA-256 hashes.
class AuthService extends ChangeNotifier {
  AuthService(this._prefs) {
    final raw = _prefs.getString(_usersKey);
    if (raw != null) {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      _users = map.map(
        (k, v) => MapEntry(k, User.fromJson(v as Map<String, dynamic>)),
      );
    }
    final name = _prefs.getString(_sessionKey);
    _current = name == null ? null : _users[name];
  }

  static const _usersKey = 'jambcbt.users';
  static const _sessionKey = 'jambcbt.session';

  final SharedPreferences _prefs;
  Map<String, User> _users = {};
  User? _current;

  User? get currentUser => _current;

  static Future<AuthService> create() async =>
      AuthService(await SharedPreferences.getInstance());

  String _hash(String password, String salt) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();

  String _newSalt() {
    final r = Random.secure();
    return base64UrlEncode(List.generate(12, (_) => r.nextInt(256)));
  }

  Future<void> _persist() => _prefs.setString(
    _usersKey,
    jsonEncode(_users.map((k, v) => MapEntry(k, v.toJson()))),
  );

  /// Returns an error message, or null on success.
  Future<String?> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    final un = username.trim().toLowerCase();
    if (_users.containsKey(un)) return 'That username is already taken.';
    final salt = _newSalt();
    final user = User(
      username: un,
      name: name.trim(),
      email: email.trim(),
      salt: salt,
      hash: _hash(password, salt),
      joined: DateTime.now(),
    );
    _users[un] = user;
    await _persist();
    await _signIn(user);
    return null;
  }

  Future<String?> login(String username, String password) async {
    final user = _users[username.trim().toLowerCase()];
    if (user == null || user.hash != _hash(password, user.salt)) {
      return 'Invalid username or password.';
    }
    await _signIn(user);
    return null;
  }

  /// Signs in (or creates) the account linked to a provider + email.
  /// Social accounts have no password, so they cannot be used with [login].
  Future<void> socialSignIn(
    SocialProvider provider, {
    required String name,
    required String email,
  }) async {
    final mail = email.trim().toLowerCase();
    final un = '${provider.name}_${mail.replaceAll(RegExp(r'[^a-z0-9]'), '_')}';
    final user =
        _users[un] ??
        User(
          username: un,
          name: name.trim(),
          email: mail,
          salt: '',
          hash: '',
          joined: DateTime.now(),
        );
    if (!_users.containsKey(un)) {
      _users[un] = user;
      await _persist();
    }
    await _signIn(user);
  }

  Future<void> _signIn(User user) async {
    _current = user;
    await _prefs.setString(_sessionKey, user.username);
    notifyListeners();
  }

  Future<void> logout() async {
    _current = null;
    await _prefs.remove(_sessionKey);
    notifyListeners();
  }

  Future<void> addAttempt(Attempt attempt) async {
    _current?.attempts.add(attempt);
    await _persist();
    notifyListeners();
  }
}
