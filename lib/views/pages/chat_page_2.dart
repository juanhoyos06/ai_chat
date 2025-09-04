import 'package:ai_chat/models/chat_message.dart';
import 'package:ai_chat/services/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;

  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      print("Foto tomada: ${photo.path}");
      // Aquí podrías:
      // - Subir la foto a tu backend
      // - Mostrarla en el chat
      // - Guardarla localmente
    }
  }

  Future<void> _handleSendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _controller.clear();

    final reply = await _chatService.sendMessage(text);

    setState(() {
      _messages.add(reply);
      _isLoading = false;
    });
  }

  Widget _buildMessage(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xFF52AA0A) : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(message.isUser ? 16 : 0),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(message.isUser ? 0 : 16),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: message.isUser ? FontWeight.w400 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _startRecording() async {
    if (await _audioRecorder.hasPermission()) {
      final directory = await getExternalStorageDirectory();
      final path =
          '${directory!.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );

      setState(() {
        _isRecording = true;
      });

      print("Grabando audio en: $path");
    }
  }

  Future<void> _stopRecording() async {
    final path = await _audioRecorder.stop();

    setState(() {
      _isRecording = false;
    });

    if (path != null) {
      print("Grabación detenida. Archivo guardado en: $path");
      // Aquí podrías:
      // - Subir el archivo de audio a tu backend
      // - Reproducir el audio grabado
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat con IA")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessage(_messages[index]),
            ),
          ),
          if (_isLoading)
            const LinearProgressIndicator(color: Color(0xFF52AA0A)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autocorrect: true,
                      controller: _controller,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.send,
                      maxLines: null,
                      maxLength: 300,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: "Escribe un mensaje...",
                        contentPadding: EdgeInsets.all(12),
                      ),
                      onSubmitted: _handleSendMessage,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt_outlined, color: Colors.black),
                    onPressed: _openCamera,
                  ),
                  IconButton(
                    icon: Icon(
                      _isRecording ? Icons.stop_circle : Icons.mic,
                      color: _isRecording ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      if (_isRecording) {
                        _stopRecording();
                      } else {
                        _startRecording();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
