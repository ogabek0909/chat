import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String userId;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('...');
        }
        return Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: isMe
                          ? const Radius.circular(12)
                          : const Radius.circular(0),
                      bottomRight: !isMe
                          ? const Radius.circular(12)
                          : const Radius.circular(0),
                    ),
                    color: isMe ? Colors.grey[300] : Colors.deepPurple,
                  ),
                  width: 140,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!['username'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe ? Colors.black : Colors.white,
                        ),
                      ),
                      Text(
                        message,
                        style: TextStyle(
                          color: isMe ? Colors.black : Colors.white,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -10,
                  left: isMe ? -5 : null,
                  right: !isMe ? -5 : null,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data!['image_url']),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
