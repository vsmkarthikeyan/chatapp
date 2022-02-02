import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({Key? key}) : super(key: key);

  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  TextEditingController _msgController = TextEditingController();
  var _messages;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgController,
              onChanged: (value) {
                if (value.isNotEmpty && value.trim() != null) {
                  setState(() {
                    _messages = value;
                  });
                }
              },
              decoration:
                  InputDecoration(labelText: 'Please enter message here...'),
            ),
          ),
          IconButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                final User user = await FirebaseAuth.instance.currentUser!;
                final userData = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get();

                FirebaseFirestore.instance.collection('chats').add({
                  'text': _messages,
                  'createdAt': Timestamp.now(),
                  'userId': user.uid,
                  'userName': userData['username'],
                  'imageUrl': userData['image_url']
                });
                _msgController.clear();
              },
              icon: Icon(Icons.send))
        ],
      ),
    );
  }
}
