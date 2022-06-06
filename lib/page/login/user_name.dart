// ignore_for_file: avoid_print, prefer_final_fields, sized_box_for_whitespace, must_be_immutable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_chat_app/page/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserName extends StatelessWidget {
  UserName({Key? key}) : super(key: key);

  var _nameController = TextEditingController();
  bool check = false;
  late String avatar = '';

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser!;

  void createUserInFirestore() {
    users
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .limit(1)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          users.add({
            'name': _nameController.text,
            'avatar': avatar,
            'status': 'Available',
            'uid': user.uid
          });
        }
      },
    ).catchError((error) {});
  }

  _saveImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();

    Reference ref = FirebaseStorage.instance.ref().child('avatar/${user.uid}');

    final XFile? image = await _picker.pickImage(source: source);

    var img = File(image!.path);

    await ref.putFile(img);

    var downloadURL = await ref.getDownloadURL();
    check = true;
    avatar = downloadURL;

    print(downloadURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ ClipOval(
                  child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                            height: 150,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Camera'),
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    _saveImage(ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.image),
                                  title: const Text('Gallery'),
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    _saveImage(ImageSource.gallery);
                                  },
                                )
                              ],
                            ),
                          ));
                },
                child: Builder(
                  builder: (context) {
                    return avatar != ''
                        ? Image.network(
                            avatar,
                            fit: BoxFit.cover,
                            cacheHeight: 150,
                            cacheWidth: 150,
                          )
                        : Image.asset(
                            'images/bg.jpg',
                            fit: BoxFit.cover,
                            cacheHeight: 150,
                            cacheWidth: 150,
                          );
                  }
                ),
              )),
          const Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              "Enter your name",
              style: TextStyle(fontSize: 25),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
            child: TextFormField(
              controller: _nameController,
              cursorColor: const Color(0xFF08C187),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.black, width: 5),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Color(0xFF08C187), width: 3)),
                  hintText: 'Your name ...'),
              keyboardType: TextInputType.text,
            ),
          ),

          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF08C187),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Text(
                  'Continue',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              onPressed: () {
                user.updateDisplayName(_nameController.text);
                user.updatePhotoURL(avatar);

                createUserInFirestore();

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              }),

          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF08C187),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Text(
                  'Exit',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              onPressed: () {
                FirebaseAuth.instance.currentUser!.delete();
                FirebaseAuth.instance.signOut();
              }),
        ],
      ),
    );
  }
}
