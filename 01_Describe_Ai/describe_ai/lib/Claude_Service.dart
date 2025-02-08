import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ClaudeService {
  final String _baseurl = 'https://api.anthropic.com/v1/messages';
  final String _apikey =
      "Your API Key"; // Get your API Key from https://anthropic.com/

  Future<String> analyzeImage(File image) async {
    // Prepare the image for the API
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);

    // Send the image to the Claude

    final response = await http.post(
      Uri.parse(_baseurl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apikey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-3-opus-20240229',
        'max-tokens': 50,
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
                'data': 'Please Describe What you see in this image'
              }
            ]
          },
        ],
      }),
    );

    // Successful response from the Claude

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['content'][0]['text'];
    } else {
      print("API Response: ${response.body}");
      throw Exception('Failed to analyze image: ${response.statusCode}');
    }
  }
}
