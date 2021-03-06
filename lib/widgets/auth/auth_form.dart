import 'dart:io';

import 'package:chatapp/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  void Function(String email, String userName, String Password, bool islogin,
      File? image, BuildContext ctx) submitfn;
  final isLoading;
  AuthForm({required this.submitfn, required this.isLoading});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var userName = '';
  var userEmail = '';
  var password = '';
  var isLogin = true;
  var _userImageFile;
  final _formKey = GlobalKey<FormState>();

  void _imagePick(File pickedImage) {
    setState(() {
      _userImageFile = pickedImage;
      print(_userImageFile.toString());
    });
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    print(_userImageFile);
    print(isLogin);
    if (_userImageFile == null && !isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text('Please upload an image')));
      return;
    }

    if (isValid!) {
      _formKey.currentState?.save();
      widget.submitfn(
          userEmail, userName, password, isLogin, _userImageFile, context);
      print(userEmail);
      print(userName);
      print(password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isLogin) UserImagePicker(_imagePick),
                  TextFormField(
                    key: ValueKey('email'),
                    onSaved: (newValue) {
                      userEmail = newValue!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter valid email address';
                      }
                      return null;
                    },
                  ),
                  if (!isLogin)
                    TextFormField(
                        key: ValueKey('username'),
                        onSaved: (newValue) {
                          userName = newValue!;
                        },
                        decoration: InputDecoration(labelText: 'User Name'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Please enter valid username more than 3 chars';
                          }
                          return null;
                        }),
                  TextFormField(
                      key: ValueKey('password'),
                      onSaved: (newValue) {
                        password = newValue!;
                      },
                      decoration: InputDecoration(labelText: 'password'),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return 'Please enter valid password more than 6 chars';
                        }
                        return null;
                      }),
                  SizedBox(height: 10),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                        onPressed: _trySubmit,
                        child: isLogin ? Text('Login') : Text('Sign up')),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: isLogin
                          ? Text('Create a new Account')
                          : Text('I Already have an account'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
