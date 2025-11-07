import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_pragma/features/auth/models/user_model.dart';

class MockAuthService {
  static const _usersKey = 'mock_users';
  static const _currentUserKey = 'current_user';
  List<UserModel> _users = [];

  MockAuthService() {
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey);

    if (usersJson != null && usersJson.isNotEmpty) {
      _users = usersJson
          .map((userStr) => UserModel.fromJson(jsonDecode(userStr)))
          .toList();
    } else {
      _users = [
        UserModel(id: '1', email: 'test@mail.com', name: 'Usuario Demo'),
      ];
      await _saveUsers();
    }
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = _users.map((u) => jsonEncode(u.toJson())).toList();
    await prefs.setStringList(_usersKey, usersJson);
  }

  Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    await _loadUsers();

    final user = _users.firstWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
      orElse: () => throw Exception('Usuario no encontrado'),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
    return user;
  }

  Future<UserModel> register(String email, String name, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    await _loadUsers();

    final exists = _users.any(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );
    if (exists) throw Exception('El usuario ya existe');

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
    );

    _users.add(newUser);
    await _saveUsers();
    return newUser;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    if (userJson == null) return null;
    final user = UserModel.fromJson(jsonDecode(userJson));

    return user;
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usersKey);
    await prefs.remove(_currentUserKey);
    _users.clear();
  }
}
