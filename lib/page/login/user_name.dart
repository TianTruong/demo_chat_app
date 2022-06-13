// ignore_for_file: avoid_print, prefer_final_fields, sized_box_for_whitespace, must_be_immutable, prefer_const_constructors

import 'dart:io';

import 'package:demo_chat_app/bloc/login/login_bloc.dart';
import 'package:demo_chat_app/page/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserName extends StatefulWidget {
  const UserName({Key? key}) : super(key: key);

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
          create: (context) => LoginBloc(), child: WireFrameUserName()),
    );
  }
}

class WireFrameUserName extends StatefulWidget {
  const WireFrameUserName({Key? key}) : super(key: key);

  @override
  State<WireFrameUserName> createState() => _WireFrameUserNameState();
}

class _WireFrameUserNameState extends State<WireFrameUserName> {
  var _nameController = TextEditingController();
  late String avatar = '';
  final user = FirebaseAuth.instance.currentUser!;

  _saveImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();

    Reference ref = FirebaseStorage.instance.ref().child('avatar/${user.uid}');

    final XFile? image = await _picker.pickImage(source: source);

    var img = File(image!.path);

    await ref.putFile(img);

    var downloadURL = await ref.getDownloadURL();
    avatar = downloadURL;

    print(downloadURL);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipOval(
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
                              // loginBloc.add(SaveImageEvent(ImageSource.camera));

                              // setState(() {});
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.image),
                            title: const Text('Gallery'),
                            onTap: () async {
                              Navigator.of(context).pop();
                              _saveImage(ImageSource.gallery);

                              // loginBloc.add(SaveImageEvent(ImageSource.gallery));
                              // setState(() {});
                            },
                          )
                        ],
                      ),
                    ));
          },
          child: Builder(builder: (context) {
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
          }),
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
              onEditingComplete: () {
                setState(() {});
              }),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF08C187),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
            ),
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Text(
                    'Continue',
                    style: TextStyle(fontSize: 15),
                  ),
                );
              },
            ),
            onPressed: () {
              print(_nameController.text);
              print(avatar);
              user.updateDisplayName(_nameController.text);
              user.updatePhotoURL(avatar);

              loginBloc
                  .add(CreateUserEvent(_nameController.text, avatar, user.uid));

              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
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
    );
  }
}
