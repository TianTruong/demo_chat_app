// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unnecessary_string_interpolations, deprecated_member_use, curly_braces_in_flow_control_structures, prefer_final_fields, prefer_typing_uninitialized_variables, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_chat_app/widget/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  var items = [
    'en',
    'vi',
  ];

  _saveImage(ImageSource source, data) async {
    final ImagePicker _picker = ImagePicker();

    Reference ref = FirebaseStorage.instance.ref().child('avatar/${user.uid}');

    final XFile? image = await _picker.pickImage(source: source);

    var img = File(image!.path);

    await ref.putFile(img);

    var downloadURL = await ref.getDownloadURL();
    user.updatePhotoURL(downloadURL);

    data.docs[0].reference.update({'avatar': downloadURL});

    print(downloadURL);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String language = Localizations.localeOf(context).toString();

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong.'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  final data = snapshot.requireData;
                  return ListView(
                    children: [
                      Center(
                        child: ClipOval(
                            child: InkWell(
                          onTap: () {
                            Get.bottomSheet(
                                buildImagePicker(
                                    context: context,
                                    onTapCamera: () async {
                                      Get.back();
                                      _saveImage(ImageSource.camera, data);
                                    },
                                    onTapGallery: () async {
                                      Get.back();
                                      _saveImage(ImageSource.gallery, data);
                                    }),
                                backgroundColor: Colors.white);
                          },
                          child: Builder(builder: (context) {
                            return user.photoURL != null
                                ? Image.network(
                                    user.photoURL!,
                                    fit: BoxFit.cover,
                                    cacheHeight: 160,
                                    cacheWidth: 160,
                                  )
                                : Image.asset(
                                    'images/bg.jpg',
                                    fit: BoxFit.cover,
                                    cacheHeight: 160,
                                    cacheWidth: 160,
                                  );
                          }),
                        )),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('${user.displayName!}',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      buildItemSettings(
                          widget: ListTile(title: Text('ID: ${user.uid}'))),
                      buildItemSettings(
                          widget:
                              ListTile(title: Text('Gmail: ${user.email!}'))),
                      ChangePass(
                        data: data,
                      ),
                      buildItemSettings(
                          widget: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: DropdownButton(
                          // hint: Text("Choose an item"),
                          value: language,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              language = newValue ?? '';

                              var locale = Locale(language);

                              if (newValue !=
                                  Localizations.localeOf(context).toString())
                                Get.updateLocale(locale);
                            });
                          },
                        ),
                      )),
                      SignOut()
                    ],
                  );
                }
                return Container();
              })),
    );
  }
}

class ChangePass extends StatefulWidget {
  const ChangePass({Key? key, required this.data}) : super(key: key);
  final data;
  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController _currentController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();

  diaChangePass() {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 325,
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTextFormField(
                    controller: _currentController,
                    hide: true,
                    hintText: AppLocalizations.of(context)!.current_password),
                buildTextFormField(
                    controller: _passController,
                    hide: true,
                    hintText: AppLocalizations.of(context)!.new_password),
                buildTextFormField(
                    controller: _confirmController,
                    hide: true,
                    hintText: AppLocalizations.of(context)!.confirm_password),
                Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF08C187),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(
                          AppLocalizations.of(context)!.change_password,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      onPressed: () {
                        if (_passController.text == '' ||
                            _confirmController.text == '' ||
                            _passController.text.isEmpty ||
                            _confirmController.text.isEmpty) {
                          Get.defaultDialog(
                            title: '',
                            content: Text(AppLocalizations.of(context)!
                                .please_enter_enough_info),
                            confirmTextColor: Colors.white,
                            confirm: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFF08C187),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                ),
                                child: Text(
                                  'Ok',
                                  style: TextStyle(fontSize: 15),
                                ),
                                onPressed: () => Get.back()),
                          );
                        } else {
                          if (_currentController.text !=
                              widget.data.docs[0]['password']) {
                            Get.defaultDialog(
                              title: '',
                              content: Text('Mật khẩu hiện tại không đúng'),
                              confirmTextColor: Colors.white,
                              confirm: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFF08C187),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                  ),
                                  child: Text(
                                    'Ok',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  onPressed: () => Get.back()),
                            );
                          } else {
                            if (_passController.text ==
                                _confirmController.text) {
                              user.updatePassword(_confirmController.text);

                              widget.data.docs[0].reference.update(
                                  {'password': _confirmController.text});

                              _passController.clear();
                              _confirmController.clear();
                              Get.back();

                              Get.snackbar(
                                  'Thông báo',
                                  AppLocalizations.of(context)!
                                      .change_successfully,
                                  // snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: Colors.white,
                                  colorText: Colors.black,
                                  messageText: Text(
                                    AppLocalizations.of(context)!
                                        .change_successfully,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ));
                            } else {
                              if (_passController.text !=
                                  _confirmController.text) {
                                Get.defaultDialog(
                                  title: '',
                                  content: Text('Xác nhận mật khẩu không đúng'),
                                  confirmTextColor: Colors.white,
                                  confirm: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color(0xFF08C187),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                      ),
                                      child: Text(
                                        'Ok',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      onPressed: () => Get.back()),
                                );
                              }
                            }
                          }
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildItemSettings(
        widget: ListTile(
      title: Text(AppLocalizations.of(context)!.change_password),
      onTap: () {
        showDialog(context: context, builder: (context) => diaChangePass());
      },
    ));
  }
}

class SignOut extends StatefulWidget {
  const SignOut({Key? key}) : super(key: key);

  @override
  State<SignOut> createState() => _SignOutState();
}

class _SignOutState extends State<SignOut> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: const Color(0xFF08C187),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            AppLocalizations.of(context)!.signout,
            style: TextStyle(fontSize: 15),
          ),
        ),
        onPressed: () {
          Get.defaultDialog(
              title: '',
              confirmTextColor: Colors.white,
              content: Text('${AppLocalizations.of(context)!.signout}?',
                  style: TextStyle(fontSize: 24)),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF08C187),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.yes,
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      Get.back();
                      FirebaseAuth.instance.signOut();
                    }),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF08C187),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.no,
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      Get.back();
                    }),
              ]);
        });
  }
}
