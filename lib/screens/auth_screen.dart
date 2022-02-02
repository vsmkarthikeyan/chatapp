import 'dart:io';

import 'package:chatapp/widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var isLoading = false;
  void _submitAuthForm(String email, String username, String password,
      bool isLogin, File? image, BuildContext ctx) async {
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        UserCredential userCredential = await auth
            .createUserWithEmailAndPassword(email: email, password: password);

        final firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(auth.currentUser!.uid.toString() + '.jpg');
        var task = await ref.putFile(image!);
        if (task.state == firebase_storage.TaskState.success) {
          var imageurl = await ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user?.uid)
              .set({
            'username': username,
            'email': email,
            'image_url': imageurl
          });
        }
      }
    } on PlatformException catch (e) {
      print(e);
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            e.message.toString(),
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: AuthForm(
        submitfn: _submitAuthForm,
        isLoading: isLoading,
      ),
    );
  }
}
