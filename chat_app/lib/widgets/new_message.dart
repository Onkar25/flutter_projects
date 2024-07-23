import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _NewMessage();
  }
}

class _NewMessage extends State<NewMessage> {
  var messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void submitMessage() async {
    final enteredMessage = messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }
    messageController.clear();
    FocusScope.of(context).unfocus();
    // Send to Firebase

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chats').add({
      'text': enteredMessage,
      'createAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['imageurl']
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 1,
        bottom: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(
                labelText: 'Send Messages ...',
              ),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: submitMessage,
            icon: const Icon(
              Icons.send,
            ),
          ),
        ],
      ),
    );
  }
}
