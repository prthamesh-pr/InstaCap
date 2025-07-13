import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiTestService {
  //static const String baseUrl = 'http://localhost:3000';

  // Production URL (uncomment for production)
  static const String baseUrl = 'https://instacap.onrender.com';

  /// Test the health endpoint to verify API connectivity
  static Future<bool> testApiHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('✅ API Health Check Successful: ${data['message']}');
        return true;
      } else {
        debugPrint('❌ API Health Check Failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ API Health Check Error: $e');
      return false;
    }
  }

  /// Test a simple API endpoint
  static Future<Map<String, dynamic>?> testApiEndpoint() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/test'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('✅ API Test Endpoint Successful: $data');
        return data;
      } else {
        debugPrint('❌ API Test Endpoint Failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ API Test Endpoint Error: $e');
      return null;
    }
  }

  /// Initialize API connection on app start
  static Future<void> initializeApiConnection() async {
    debugPrint('🔗 Initializing API connection...');
    final isHealthy = await testApiHealth();

    if (isHealthy) {
      debugPrint('🚀 Successfully connected to InstaCap API at $baseUrl');
    } else {
      debugPrint(
          '⚠️ Could not connect to InstaCap API. Check your internet connection.');
    }
  }
}
