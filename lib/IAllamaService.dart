import 'dart:convert';
import 'package:http/http.dart' as http;

class LlamaService {
  final String _apiKey = "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";
  final String _endpoint = "https://api.groq.com/openai/v1/chat/completions";

  Future<String> generateText(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
        },
        body: jsonEncode({
          "model": "llama-3.1-8b-instant",
          "messages": [
            {
              "role": "system",
              "content":
                  "Eres un recomendador de libros experto. Responde siempre en español."
            },
            {
              "role": "user",
              "content": prompt,
            }
          ],
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        // --- Evita error del APK ---
        final bodyUtf8 = utf8.decode(response.bodyBytes);
        final data = jsonDecode(bodyUtf8);

        if (data["choices"] == null || data["choices"].isEmpty) {
          return "Lo siento, no puedo procesar tu solicitud en este momento.";
        }

        return data["choices"][0]["message"]["content"];
      } else {
        print("Groq Error (${response.statusCode}) → ${response.body}");
        return "Error del servidor (${response.statusCode}). Intenta de nuevo.";
      }
    } catch (e) {
      print("Exception Groq → $e");
      return "Error de conexión. Revisa tu internet.";
    }
  }
}
