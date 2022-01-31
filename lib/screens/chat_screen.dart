import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('/chats/7L6gcZtp3rNHZfpRpPML/messages')
              .add({'text': 'This is added from the app'});
        },
      ),
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('/chats/7L6gcZtp3rNHZfpRpPML/messages')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return (Center(
                child: CircularProgressIndicator(),
              ));
            }
            final documents = snapshot.data?.docs;
            return ListView.builder(
                itemCount: documents?.length,
                itemBuilder: (ctx, index) {
                  return Text(documents![index]['text']);
                });
          }),
    );
  }
}
