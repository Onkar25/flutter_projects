import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final uathenticateUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy(
              'createAt',
              descending: true,
            )
            .snapshots(),
        builder: (ctx, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshots.hasError) {
            const Center(
              child: Text(
                'Something went Wrong here !!!',
              ),
            );
          }

          if (snapshots.hasData || snapshots.data!.docs.isEmpty) {
            const Center(
              child: Text(
                'No Message found !!!',
              ),
            );
          }
          final loadedMessage = snapshots.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.only(
              bottom: 40,
              right: 16,
              left: 16,
            ),
            reverse: true,
            itemCount: loadedMessage.length,
            itemBuilder: (ctx, index) {
              final chatMessage = loadedMessage[index].data();
              final nextChatMessage = index + 1 < loadedMessage.length
                  ? loadedMessage[index + 1].data()
                  : null;

              final currentMessageUserId = chatMessage['userId'];
              final nextMessageUserId =
                  nextChatMessage != null ? nextChatMessage['userId'] : null;

              final isNextUserSame = nextMessageUserId == currentMessageUserId;
              if (isNextUserSame) {
                return MessageBubble.next(
                    message: chatMessage['text'],
                    isMe: uathenticateUser.uid == currentMessageUserId);
              } else {
                return MessageBubble.first(
                    userImage: chatMessage['userImage'],
                    username: chatMessage['username'],
                    message: chatMessage['text'],
                    isMe: uathenticateUser.uid == currentMessageUserId);
              }
            },
          );
        });
  }
}
