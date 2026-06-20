import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // IP Config Rule: 
  // Android Emulator use kar rahe ho toh 'http://10.0.2.2:8000' standard hai.
  // iOS Simulator ke liye 'http://127.0.0.1:8000' chalega.
  // Real Phone ke liye laptop ka local IP address daalna (e.g., 'http://192.168.1.5:8000').
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<bool> addCallLog({
    required String title,
    required String callerId,
    required String status,
    required int threatScore,
  }) async {
    final url = Uri.parse('$baseUrl/api/logs/add');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'caller_id': callerId,
          'status': status,
          'threat_score': threatScore,
        }),
      );

      if (response.statusCode == 200) {
        print("🎉 Notion Sync Done: ${response.body}");
        return true;
      } else {
        print("❌ Backend Validation Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("🔌 Connection Failed (Check if FastAPI is running): $e");
      return false;
    }
  }
}
