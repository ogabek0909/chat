import 'package:chat/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
                'Something went wrong, Please check your internet connetion!'),
          );
        } else {
          final chatDocs = snapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              return MessageBubble(
                message: chatDocs[index]['text'],
                isMe: chatDocs[index]['userId'] ==
                    FirebaseAuth.instance.currentUser!.uid,
                userId: chatDocs[index]['userId'],
                key: ValueKey(
                  chatDocs[index].id,
                ),
              );
            },
          );
        }
      },
    );
  }
}
