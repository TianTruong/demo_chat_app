// ignore_for_file: prefer_final_fields, prefer_const_constructors, avoid_print, non_constant_identifier_names, deprecated_member_use

import 'dart:ui';

import 'package:demo_chat_app/page/login/user_name.dart';
import 'package:demo_chat_app/widget/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _gmailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _gmailController.dispose();
    _passController.dispose();
    _confirmController.dispose();
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
                  return UserName(pass: _passController.text);
                }
                return Column(
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
                    buildTextFormField(
                        controller: _gmailController,
                        hide: false,
                        hintText: AppLocalizations.of(context)!.gmail),
                    buildTextFormField(
                        controller: _passController,
                        hide: true,
                        hintText: AppLocalizations.of(context)!.password),
                    buildTextFormField(
                        controller: _confirmController,
                        hide: true,
                        hintText:
                            AppLocalizations.of(context)!.confirm_password),
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
                            AppLocalizations.of(context)!.signup,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        onPressed: CheckSignUp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.have_an_account),
                        CupertinoButton(
                            child: Text(AppLocalizations.of(context)!.signin,
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              Get.back();
                            })
                      ],
                    )
                  ],
                );
              },
            ),
          )),
    );
  }

  Future CheckSignUp() async {
    if (_gmailController.text == '' ||
        _passController.text == '' ||
        _confirmController.text == '' ||
        _gmailController.text.isEmpty ||
        _passController.text.isEmpty ||
        _confirmController.text.isEmpty) {
      Get.defaultDialog(
        title: '',
        content: Text(AppLocalizations.of(context)!.please_enter_enough_info),
        confirmTextColor: Colors.white,
        confirm: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF08C187),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
            ),
            child: Text(
              'Ok',
              style: TextStyle(fontSize: 15),
            ),
            onPressed: () => Get.back()),
      );
    } else {
      if (_passController.text != _confirmController.text) {
        Get.defaultDialog(
          title: '',
          content: Text('Xác nhận mật khẩu không đúng'),
          confirmTextColor: Colors.white,
          confirm: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF08C187),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
              child: Text(
                'Ok',
                style: TextStyle(fontSize: 15),
              ),
              onPressed: () => Get.back()),
        );
      } else {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _gmailController.text.trim(),
              password: _passController.text.trim());
        } on FirebaseAuthException catch (e) {
          print(e);

          Get.dialog(AlertDialog(
            content: Text(e.toString().trim()),
            actions: [
              FlatButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Get.back();
                  }),
            ],
          ));

          // Get.snackbar('Error', e.toString().trim(),
          //     // snackPosition: SnackPosition.BOTTOM,
          //     duration: const Duration(seconds: 2),
          //     backgroundColor: Colors.white,
          //     colorText: Colors.black,
          //     messageText: Text(
          //       e.toString().trim(),
          //       style: TextStyle(fontWeight: FontWeight.w500),
          //     ));
        }
      }
    }
  }
}
