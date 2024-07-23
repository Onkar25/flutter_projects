import 'package:chat_app/widgets/message.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  void requestFCM() async {
    final fcm = FirebaseMessaging.instance;
    fcm.requestPermission();
    // final token = await fcm.getToken();
    // print('TOKEN : $token');
    fcm.subscribeToTopic('flutter_chat_app');
  }

  @override
  void initState() {
    super.initState();
    requestFCM();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chat App',
          ),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: const Column(
          children: [
            Expanded(
              child: ChatMessage(),
            ),
            NewMessage(),
          ],
        ));
  }
}
