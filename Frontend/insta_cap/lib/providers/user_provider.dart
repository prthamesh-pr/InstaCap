import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  User? _currentUser;
  UserStats? _userStats;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  UserStats? get userStats => _userStats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> loadUserProfile() async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _apiService.getUserProfile();

      if (response['success'] == true) {
        _currentUser = User.fromJson(response['user'] ?? {});
      } else {
        _setError(response['message'] ?? 'Failed to load user profile');
      }

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<bool> updateUserProfile(Map<String, dynamic> profileData) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _apiService.updateUserProfile(profileData);

      if (response['success'] == true) {
        _currentUser = User.fromJson(response['user'] ?? {});
        _setLoading(false);
        return true;
      } else {
        _setError(response['message'] ?? 'Failed to update profile');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> loadUserStats() async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _apiService.getUserStats();

      if (response['success'] == true) {
        _userStats = UserStats.fromJson(response['stats'] ?? {});
      } else {
        _setError(response['message'] ?? 'Failed to load user stats');
      }

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  void clearUserData() {
    _currentUser = null;
    _userStats = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _setError(null);
  }
}
