import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Row(
                    children:const [
                      Icon(Icons.exit_to_app,color: Colors.black),
                      SizedBox(width: 8),
                      Text("Logout"),
                    ],
                  ),
                  onTap: () async{
                    await FirebaseAuth.instance.signOut();
                  },
                ),
              ];
            },
          ),
        ],
      ),
      backgroundColor: Colors.cyan,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/U0GiyagQ9SNgOzrWMhLy/messages')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LinearProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          } else {
            final documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  documents[index]['text'],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/U0GiyagQ9SNgOzrWMhLy/messages')
              .add(
            {
              'text': 'This was added by clicking the button',
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
