import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  String? _error;
  bool _loading = false;

  UserModel? get user => _user;
  String? get error => _error;
  bool get loading => _loading;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final map = json.decode(userJson) as Map<String, dynamic>;
      _user = UserModel(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        favorites: List<String>.from(map['favorites'] ?? []),
        imagePath: map['imagePath'],
      );
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _user = UserModel(
      id: '1',
      name: 'Demo User',
      email: email,
      favorites: [],
      imagePath: null,
    );
    await _saveUserToPrefs();
    _loading = false;
    notifyListeners();
  }

  Future<void> signup(String name, String email, String password) async {
    await login(email, password);
    if (_user != null) {
      _user = UserModel(
        id: _user!.id,
        name: name,
        email: email,
        favorites: _user!.favorites,
        imagePath: null,
      );
      await _saveUserToPrefs();
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    notifyListeners();
  }

  void updateUser({String? name, String? email, String? imagePath, String? phone}) async {
    if (_user != null) {
      _user = UserModel(
        id: _user!.id,
        name: name ?? _user!.name,
        email: email ?? _user!.email,
        favorites: _user!.favorites,
        imagePath: imagePath ?? _user!.imagePath,
        phone: phone ?? _user!.phone,
      );
      await _saveUserToPrefs();
      notifyListeners();
    }
  }

  Future<void> _saveUserToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (_user != null) {
      final userMap = {
        'id': _user!.id,
        'name': _user!.name,
        'email': _user!.email,
        'favorites': _user!.favorites,
        'imagePath': _user!.imagePath,
      };
      await prefs.setString('user', json.encode(userMap));
    }
  }
}