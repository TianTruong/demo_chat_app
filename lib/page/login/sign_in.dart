// ignore_for_file: prefer_final_fields, avoid_print, non_constant_identifier_names, prefer_const_constructors, deprecated_member_use

import 'dart:async';
import 'dart:ui';

import 'package:demo_chat_app/page/home/home_page.dart';
import 'package:demo_chat_app/page/login/sign_up.dart';
import 'package:demo_chat_app/page/login/user_name.dart';
import 'package:demo_chat_app/widget/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

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
                    return UserName(pass: _passController.text);
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
                          buildTextFormField(
                              controller: _gmailController,
                              hide: false,
                              hintText: AppLocalizations.of(context)!.gmail),
                          buildTextFormField(
                              controller: _passController,
                              hide: true,
                              hintText: AppLocalizations.of(context)!.password),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xFF08C187),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Text(
                                  AppLocalizations.of(context)!.signin,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              onPressed: CheckSignIn),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(AppLocalizations.of(context)!.no_account),
                              CupertinoButton(
                                  child: Text(
                                      AppLocalizations.of(context)!.signup,
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () {
                                    Get.to(const SignUp());
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
                content: Text(
                    AppLocalizations.of(context)!.please_enter_enough_info),
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
