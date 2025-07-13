import 'package:flutter/material.dart';
import 'dart:io';

import '../services/api_service.dart';
import '../models/caption_model.dart';

class CaptionProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<CaptionData> _captions = [];
  List<CaptionData> _history = [];
  bool _isLoading = false;
  String? _error;

  List<CaptionData> get captions => _captions;
  List<CaptionData> get history => _history;
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

  Future<bool> generateCaptions({
    File? imageFile,
    String style = 'casual',
    String platform = 'instagram',
    String? prompt,
    int count = 3,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _apiService.generateCaptions(
        imageFile: imageFile,
        style: style,
        platform: platform,
        prompt: prompt,
        count: count,
      );

      if (response.success) {
        _captions = response.data ?? [];

        // Add to history
        if (_captions.isNotEmpty) {
          _history.insertAll(0, _captions);
          // Keep only last 50 items in history
          if (_history.length > 50) {
            _history = _history.take(50).toList();
          }
        }

        _setLoading(false);
        return true;
      } else {
        _setError(response.message ?? 'Failed to generate captions');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> generateMoreCaptions({
    File? imageFile,
    String style = 'casual',
    String platform = 'instagram',
    String? prompt,
    int count = 3,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _apiService.generateCaptions(
        imageFile: imageFile,
        style: style,
        platform: platform,
        prompt: prompt,
        count: count,
      );

      if (response.success) {
        final newCaptions = response.data ?? [];
        _captions.addAll(newCaptions);

        // Add to history
        if (newCaptions.isNotEmpty) {
          _history.insertAll(0, newCaptions);
          // Keep only last 50 items in history
          if (_history.length > 50) {
            _history = _history.take(50).toList();
          }
        }

        _setLoading(false);
        return true;
      } else {
        _setError(response.message ?? 'Failed to generate more captions');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> loadHistory() async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _apiService.getCaptionHistory();

      if (response.success) {
        _history = response.data ?? [];
      } else {
        _setError(response.message ?? 'Failed to load history');
      }

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<bool> saveCaption(CaptionData caption) async {
    try {
      final response = await _apiService.saveCaption(caption);

      if (response['success'] == true) {
        // Update the caption in the lists
        final index = _captions.indexWhere((c) => c.id == caption.id);
        if (index != -1) {
          _captions[index] = caption.copyWith(saved: true);
        }

        final historyIndex = _history.indexWhere((c) => c.id == caption.id);
        if (historyIndex != -1) {
          _history[historyIndex] = caption.copyWith(saved: true);
        }

        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteCaption(String captionId) async {
    try {
      final response = await _apiService.deleteCaption(captionId);

      if (response['success'] == true) {
        _captions.removeWhere((c) => c.id == captionId);
        _history.removeWhere((c) => c.id == captionId);
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  void clearCaptions() {
    _captions.clear();
    notifyListeners();
  }

  void clearError() {
    _setError(null);
  }
}
