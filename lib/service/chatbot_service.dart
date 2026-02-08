import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  final String baseUrl = "https://ampora.dev/ml/chat";

  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> message) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(message),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Chatbot error");
    }
  }
}
