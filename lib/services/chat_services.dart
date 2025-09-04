import 'dart:convert';
import 'package:ai_chat/models/chat_message.dart';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl = "http://10.0.2.2:8000/send_message/";
  
  // El historial se mantiene en Flutter
  final List<Map<String, String>> _history = [];

  Future<ChatMessage> sendMessage(String text) async {
    // Guardamos mensaje del usuario en historial
    _history.add({"role": "user", "content": text});

    try {
      final url = Uri.parse("$baseUrl?messages=${Uri.encodeComponent(text)}");


      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"messages": _history}), // enviamos todo el historial
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Guardamos respuesta de la IA en historial
        _history.add({"role": "assistant", "content": data["response"]});

        return ChatMessage(
          text: data["response"] ?? "Respuesta vacía",
          isUser: false,
        );
      } else {
        return ChatMessage(
          text: "Error: ${response.statusCode}",
          isUser: false,
        );
      }
    } catch (e) {
      return ChatMessage(
        text: "Error de conexión: $e",
        isUser: false,
      );
    }
  }
}
