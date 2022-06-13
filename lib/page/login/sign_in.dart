// ignore_for_file: prefer_final_fields, avoid_print, non_constant_identifier_names, prefer_const_constructors, deprecated_member_use

import 'dart:async';
import 'dart:ui';

import 'package:demo_chat_app/page/home/home_page.dart';
import 'package:demo_chat_app/page/login/sign_up.dart';
import 'package:demo_chat_app/page/login/user_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginGmail extends StatefulWidget {
  const LoginGmail({Key? key}) : super(key: key);

  @override
  State<LoginGmail> createState() => _LoginGmailState();
}

class _LoginGmailState extends State<LoginGmail> {
  TextEditingController _gmailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    _gmailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  buildTextFormField(TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.black, width: 5),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Color(0xFF08C187), width: 3)),
            hintText: hintText),
        keyboardType: TextInputType.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  image: AssetImage('images/bg.jpg'), fit: BoxFit.fill)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }

                if (snapshot.hasData) {
                  if (FirebaseAuth.instance.currentUser!.displayName == null) {
                    return UserName();
                  }
                  return HomePage();
                }
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            shape: BoxShape.rectangle,
                            color: Colors.white.withOpacity(0.5)),
                        child: const Image(
                          image: AssetImage('images/whatsapp.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildTextFormField(_gmailController, 'Gmail'),
                          buildTextFormField(_passController, 'Password'),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xFF08C187),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              onPressed: CheckSignIn),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('No account? '),
                              CupertinoButton(
                                  child: const Text('Sign Up',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUp()));
                                  })
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          )),
    );
  }

  Future CheckSignIn() async {
    if (_gmailController.text == '' ||
        _passController.text == '' ||
        _gmailController.text.isEmpty ||
        _passController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text('Please enter some text'),
                actions: [
                  FlatButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              ));
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _gmailController.text.trim(),
            password: _passController.text.trim());
      } on FirebaseAuthException catch (e) {
        print(e);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text(e.toString().trim()),
                  actions: [
                    FlatButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ));
      }
    }
  }
}
