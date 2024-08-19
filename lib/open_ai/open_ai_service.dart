import 'dart:convert';
import 'package:cxai_motorcycle_rides/env/env.dart';
import 'package:http/http.dart' as http;

class OpenAiService {
  final String openAiKey = Env.openAiApiKey;
  final String googleMapsKey = Env.googleMapsApiKey;

  Future<String> getMapsLinkFromPrompt(String prompt) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/engines/davinci-codex/completions'),
      headers: {
        'Authorization': 'Bearer $openAiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prompt': prompt,
        'max_tokens': 50, // Adjust as needed
        'temperature': 0.7, // Adjust creativity of the response
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['choices'][0]['text'].trim();
      print(text);

      String regexPattern = r'https:\/\/www\.google\.com\/maps\/dir\/[^\]]+';

      RegExp regExp = RegExp(regexPattern);
      Match? match = regExp.firstMatch(text);

      if (match != null) {
        print('Match found');
        String mapsLink = match.group(0)!;
        mapsLink = mapsLink.replaceAll('YOUR_API_KEY', googleMapsKey);
        return mapsLink;
      } else {
        throw Exception('Failed to extract Google Maps link from response');
      }
    } else {
      throw Exception('Failed to get response from ChatGPT. Status code: ${response.statusCode}');
    }
  }
}
