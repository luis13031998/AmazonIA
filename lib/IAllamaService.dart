import 'dart:convert'; // Import 'dart:convert' to use utf8.decode
import 'package:http/http.dart' as http;

class LlamaService {
  final String _apiKey = "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";
  final String _endpoint = "https://api.groq.com/openai/v1/chat/completions";

  Future<String> generateText(String prompt) async {
    try { // Added try-catch for better error handling
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "llama3-8b-8192",
          "messages": [
            {
              "role": "system",
              "content": "Eres un recomendador de libros experto. Sugiere libros similares o relacionados basados en el gusto del usuario."
            },
            {"role": "user", "content": prompt}
          ],
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        // --- THIS IS THE KEY CHANGE ---
        // Decode the raw bytes of the response body as UTF-8
        final String decodedBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedBody); // Now decode the correctly encoded string
        return data['choices'][0]['message']['content'];
      } else {
        // Print the full response body for debugging API errors
        print("Groq API Error Status: ${response.statusCode}");
        print("Groq API Error Body: ${response.body}");
        throw Exception("Error Groq: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      // Catch any network or decoding errors
      print("Network or Decoding Exception: $e");
      throw Exception("Failed to get recommendation: $e");
    }
  }
}