import 'package:chatapp/widgets/chats/messages.dart';
import 'package:chatapp/widgets/chats/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat App'),
          actions: [
            DropdownButton(
                icon: Icon(Icons.more_vert),
                items: [
                  DropdownMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Log out')
                        ],
                      )),
                ],
                onChanged: (itemIdentifier) async {
                  await FirebaseAuth.instance.signOut();
                })
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: messages(),
              ),
              NewMessages(),
            ],
          ),
        ));
  }
}
