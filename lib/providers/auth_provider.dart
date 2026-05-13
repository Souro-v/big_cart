import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  void _setLoading(bool val) { _isLoading = val; notifyListeners(); }
  void _setError(String? val) { _error = val; notifyListeners(); }

  Future<bool> login(String email, String password) async {
    _setLoading(true); _setError(null);
    try {
      _user = await _authService.login(email: email, password: password);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String name, String email, String password, String phone) async {
    _setLoading(true); _setError(null);
    try {
      _user = await _authService.register(
        name: name, email: email, password: password, phone: phone,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> forgotPassword(String email) async {
    _setLoading(true); _setError(null);
    try {
      await _authService.forgotPassword(email);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> updateUser(UserModel updated) async {
    await _authService.updateUser(updated);
    _user = updated;
    notifyListeners();
  }
}