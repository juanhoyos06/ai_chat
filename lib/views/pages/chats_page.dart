import 'package:ai_chat/views/pages/chat_page_2.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats'), actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage()),
            );
          },
        ),
      ]),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                buildChat('Chat 1', 'Este es el primer chat de prueba'),
                Divider(indent: 16, endIndent: 16),
                buildChat('Chat 2', 'Este es el segundo chat de prueba'),
                Divider(indent: 16, endIndent: 16),
                buildChat('Chat 3', 'Este es el tercer chat de prueba'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector buildChat(String title, String description) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        //
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8,
              ),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.chat),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(title), Text(description)],
            ),
          ],
        ),
      ),
    );
  }
}
