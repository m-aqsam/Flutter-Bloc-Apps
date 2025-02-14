import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ClaudeService {
  final String _baseurl = 'https://api.anthropic.com/v1/messages';
  final String _apikey = "Your_API_Key"; // Keep it secure

  Future<String> analyzeImage(File image) async {
    try {
      // Convert image to Base64
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      // API Request Body
      final requestBody = jsonEncode({
        'model': 'claude-3-opus-20240229',
        'max_tokens': 200,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'image',
                'source': {
                  'type': 'base64',
                  'media_type': 'image/jpeg',
                  'data': base64Image,
                }
              },
              {
                'type': 'text',
                'text': 'Please describe what you see in this image.'
              }
            ]
          },
        ],
      });

      // Send request to Claude API
      final response = await http.post(
        Uri.parse(_baseurl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apikey,
          'anthropic-version': '2023-06-01',
        },
        body: requestBody,
      );

      // Debugging API Response
      print("API Response: ${response.body}");

      // Handle Response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content']?[0]?['text'] ?? "No description available.";
      } else {
        throw Exception('Failed to analyze image: ${response.statusCode}');
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
