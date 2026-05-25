import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchProvider extends ChangeNotifier {
  List<String> _history = [];
  static const String _key = 'search_history';
  static const int _maxHistory = 10;

  List<String> get history => _history;

  SearchProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _history = prefs.getStringList(_key) ?? [];
    notifyListeners();
  }

  Future<void> addToHistory(String query) async {
    if (query.isEmpty) return;
    _history.remove(query);
    _history.insert(0, query);
    if (_history.length > _maxHistory) {
      _history = _history.sublist(0, _maxHistory);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _history);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    notifyListeners();
  }

  Future<void> removeItem(String query) async {
    _history.remove(query);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _history);
    notifyListeners();
  }
}