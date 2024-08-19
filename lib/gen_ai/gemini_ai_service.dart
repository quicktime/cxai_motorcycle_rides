import 'package:cxai_motorcycle_rides/env/env.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiAiService {
  final String geminiApiKey = Env.geminiApiKey;
  final String mapsApiKey = Env.googleMapsApiKey;

  Future<String> getLinkFromPrompt(String prompt) async {
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: geminiApiKey,
        systemInstruction: Content.system(
            'You are a very skilled motorcycle rider, trying to plan out a fun ride. Your response must be a Google Maps Directions API Link.'));
    final content = [Content.text(prompt)];
    try {
      final response = await model.generateContent(content);

      final text = response.text!.trim();

      String regexPattern = r'https:\/\/maps\.googleapis\.com\/maps\/api\/directions\/json\?[^ ]+';

      RegExp regExp = RegExp(regexPattern);
      Match? match = regExp.firstMatch(text);

      if (match != null) {
        String mapsLink = match.group(0)!;
        mapsLink = mapsLink.replaceAll('YOUR_API_KEY', mapsApiKey);
        return mapsLink;
      } else {
        throw Exception('Failed to extract Google Maps link from response');
      }
    } catch (e) {
      throw Exception('Failed to get response from ChatGPT');
    }
  }
}
