import 'package:chatapp/widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var isLoading = false;
  void _submitAuthForm(String email, String username, String password,
      bool isLogin, BuildContext ctx) async {
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
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({'username': username, 'email': email});
      }
    } on PlatformException catch (e) {
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
      setState(() {
        isLoading = false;
      });
      print(error);
    }
    setState(() {
      isLoading = false;
    });
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
