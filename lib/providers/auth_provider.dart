import 'package:big_cart/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/crashlytics_service.dart';
import '../utils/error_handler.dart';
import 'analytics_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;

  bool get isLoading => _isLoading;

  String? get error => _error;

  bool get isLoggedIn => _user != null;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _setError(String? val) {
    _error = val;
    notifyListeners();
  }

  // login method
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      _user = await _authService.login(email: email, password: password);
      await AnalyticsService().logLogin('email');
      await CrashlyticsService().setUser(_user!.uid, _user!.email);

      notifyListeners();
      return true;
    } catch (e) {
      _setError(ErrorHandler.getMessage(e)); // ← update
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // register method
  Future<bool> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    _setLoading(true);
    _setError(null);
    try {
      _user = await _authService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      await AnalyticsService().logSignUp('email');
      notifyListeners();
      return true;
    } catch (e) {
      _setError(ErrorHandler.getMessage(e)); // ← update
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // forgotPassword method
  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    _setError(null);
    try {
      await _authService.forgotPassword(email);
      return true;
    } catch (e) {
      _setError(ErrorHandler.getMessage(e)); // ← update
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    await CrashlyticsService().clearUser();
    _user = null;
    notifyListeners();
  }
  Future<void> updateUser(UserModel updated) async {
    await _authService.updateUser(updated);
    _user = updated;
    notifyListeners();
  }
}
