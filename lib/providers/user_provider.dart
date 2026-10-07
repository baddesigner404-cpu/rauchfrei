import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_data.dart';

class UserProvider with ChangeNotifier {
  UserData? _userData;
  bool _isLoaded = false;

  UserData? get userData => _userData;
  bool get isLoaded => _isLoaded;
  bool get isFirstLaunch => _userData == null;

  UserProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('user_data');
    if (dataString != null) {
      _userData = UserData.fromJson(json.decode(dataString));
    }
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> saveUserData(UserData data) async {
    _userData = data;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', json.encode(data.toJson()));
    notifyListeners();
  }
}
