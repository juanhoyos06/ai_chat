import 'dart:convert';
import 'dart:io';
import 'package:ai_chat/models/chat_message.dart';
import 'package:http/http.dart' as http;

class ChatService {
  final List<Map<String, String>> _history = [];

  Future<ChatMessage> sendMessage(String text) async {
    // Guardamos mensaje del usuario en historial
    final String baseUrl = "http://10.0.2.2:8000/send_message/";

    // El historial se mantiene en Flutter
    
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
      return ChatMessage(text: "Error de conexión: $e", isUser: false);
    }
  }
  Future<String> transcribeAudio(File audioFile) async {
    final String baseUrl = "http://10.0.2.2:8000/send_audio/";

    try {
      final request = http.MultipartRequest("POST", Uri.parse(baseUrl));
      request.files.add(await http.MultipartFile.fromPath("file", audioFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        return jsonDecode(responseData)["transcription"] ?? "Transcripción vacía";
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Error de conexión: $e";
    }
  }
}
