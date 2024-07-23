import 'dart:io';
import 'package:chat_app/widgets/user_picker_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return AuthScreenState();
  }
}

class AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmailId = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  File? _pickedImage;
  var _isAuthenticating = false;

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || (!_isLogin && _pickedImage == null)) {
      return;
    }
    _form.currentState!.save();
    try {
      _isAuthenticating = true;
      if (_isLogin) {
        // Login here
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmailId, password: _enteredPassword);
        // print(userCredentials);
      } else {
        // Sign up here

        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmailId, password: _enteredPassword);

        final firebaseRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await firebaseRef.putFile(_pickedImage!);
        final imageurl = await firebaseRef.getDownloadURL();
        // print(imageurl);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'emailid': _enteredEmailId,
          'imageurl': imageurl,
        });

        // print(link);
      }
      _isAuthenticating = false;
    } on FirebaseAuthException catch (error) {
      if (error.code == '') {
        /// Some code related logic
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message ?? 'Authentication Sign up failed',
          ),
        ),
      );
      _isAuthenticating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  right: 20,
                  left: 20,
                  top: 30,
                  bottom: 20,
                ),
                width: 200,
                child: Image.asset(
                  'assets/images/chat.png',
                ),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onPickedImage: (file) {
                                _pickedImage = file;
                              },
                            ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Username',
                              ),
                              enableSuggestions: true,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 4) {
                                  return "Username should atleast be 6 character long";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enteredUsername = newValue!;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  (!(value.contains('@') &&
                                      value.contains('.')))) {
                                return "Please enter valid email address";
                              }

                              return null;
                            },
                            onSaved: (newValue) {
                              _enteredEmailId = newValue!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 6) {
                                return "Password should atleast be 6 character long";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _enteredPassword = newValue!;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (_isAuthenticating)
                                const CircularProgressIndicator(),
                              if (!_isAuthenticating)
                                ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ),
                                  child: Text(_isLogin ? 'Login' : 'Sign Up'),
                                ),
                              const SizedBox(
                                width: 16,
                              ),
                              if (!_isAuthenticating)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  child: Text(
                                    _isLogin
                                        ? 'Create an Account '
                                        : 'I already have account',
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
