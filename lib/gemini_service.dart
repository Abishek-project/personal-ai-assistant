import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> geminiTextAPI(String prompt) async {
  final List<Map<String, String>> messages = [];
  messages.add({'role': 'user', 'content': prompt});

  try {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=AIzaSyAJUmZwCGdMwhvRCCrOmN-8VlvMkG5mfOI',
    );

    /// 🧠 Define assistant identity + personality
    const String systemInstruction = """
You are Jarvis, an intelligent AI assistant created by Abishek.
You are polite, confident, and helpful.
Always refer to yourself as Jarvis and mention Abishek when asked who created you.
Respond in a friendly but concise tone.
""";

    /// 👇 Include both system instruction + short reply constraint
    final body = {
      "system_instruction": {
        "parts": [
          {"text": systemInstruction},
        ],
      },
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": "$prompt\n\nPlease reply in maximum 2 lines."},
          ],
        },
      ],
    };

    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': 'AIzaSyAJUmZwCGdMwhvRCCrOmN-8VlvMkG5mfOI',
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];

      if (text != null) {
        messages.add({'role': 'assistant', 'content': text});
        return text.trim();
      } else {
        return 'No text response found';
      }
    } else {
      return 'Error ${res.statusCode}: ${res.body}';
    }
  } catch (e) {
    return 'Error: $e';
  }
}
