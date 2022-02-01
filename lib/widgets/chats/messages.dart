import 'package:chatapp/widgets/chats/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class messages extends StatefulWidget {
  const messages({Key? key}) : super(key: key);

  @override
  _messagesState createState() => _messagesState();
}

class _messagesState extends State<messages> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: Future.delayed(const Duration(milliseconds: 500), () {
          return FirebaseAuth.instance.currentUser!;
        }),
        builder: (context, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .orderBy('createdAt', descending: false)
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
                    print(documents![index]['text']);
                    return MessageBubble(
                        documents![index]['text'],
                        documents[index]['userName'],
                        documents[index]['userId'] == futureSnapshot.data?.uid);
                  });
            },
          );
        });
  }
}
