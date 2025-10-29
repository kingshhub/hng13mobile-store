import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreProvider extends ChangeNotifier {
  String? _storeName;
  bool _isInitialized = false;

  String? get storeName => _storeName;
  bool get isInitialized => _isInitialized;

  Future<void> loadStoreName() async {
    final prefs = await SharedPreferences.getInstance();
    _storeName = prefs.getString('storeName');
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setStoreName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    _storeName = name;
    await prefs.setString('storeName', name);
    notifyListeners();
  }

  Future<void> clearStoreName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('storeName');
    _storeName = null;
    notifyListeners();
  }
}
