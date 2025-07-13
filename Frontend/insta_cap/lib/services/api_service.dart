import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../models/caption_model.dart';

class ApiService {
  // For local development, use local backend
  static const String baseUrl = 'http://localhost:3000/api';

  // Production API URL (uncomment for production)
  // static const String baseUrl = 'https://instacap.onrender.com/api';

  // For testing with Android emulator:
  // static const String baseUrl = 'http://10.0.2.2:3000/api';

  final http.Client _client = http.Client();

  Future<Map<String, String>> _getHeaders() async {
    final user = FirebaseAuth.instance.currentUser;
    String? token;

    if (user != null) {
      token = await user.getIdToken();
    }

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<CaptionResponse> generateCaptions({
    File? imageFile,
    String style = 'casual',
    String platform = 'instagram',
    String? prompt,
    int count = 3,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/captions/analyze-image');

      // Create multipart request if image is provided
      if (imageFile != null) {
        final request = http.MultipartRequest('POST', uri);

        // Add headers
        final headers = await _getHeaders();
        request.headers.addAll(headers);

        // Add fields
        request.fields['style'] = style;
        request.fields['platform'] = platform;
        request.fields['count'] = count.toString();
        if (prompt != null) request.fields['prompt'] = prompt;

        // Add image file
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return CaptionResponse.fromJson(data);
        } else {
          throw Exception(
              'Failed to generate captions: ${response.statusCode}');
        }
      } else {
        // Text-only generation (fallback)
        final response = await _client.post(
          uri,
          headers: await _getHeaders(),
          body: json.encode({
            'style': style,
            'platform': platform,
            'count': count,
            'prompt': prompt,
          }),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return CaptionResponse.fromJson(data);
        } else {
          throw Exception(
              'Failed to generate captions: ${response.statusCode}');
        }
      }
    } catch (e) {
      return CaptionResponse(
        success: false,
        message: e.toString(),
        count: 0,
      );
    }
  }

  Future<CaptionResponse> getCaptionHistory() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/captions/history'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CaptionResponse.fromJson(data);
      } else {
        throw Exception('Failed to load history: ${response.statusCode}');
      }
    } catch (e) {
      return CaptionResponse(
        success: false,
        message: e.toString(),
        count: 0,
      );
    }
  }

  Future<Map<String, dynamic>> saveCaption(CaptionData caption) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/captions/save'),
        headers: await _getHeaders(),
        body: json.encode(caption.toJson()),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to save caption: ${response.statusCode}');
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> deleteCaption(String captionId) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/captions/$captionId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to delete caption: ${response.statusCode}');
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/users/profile'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get user profile: ${response.statusCode}');
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> profileData) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/users/profile'),
        headers: await _getHeaders(),
        body: json.encode(profileData),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/users/stats'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get user stats: ${response.statusCode}');
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  void dispose() {
    _client.close();
  }
}
