// ignore_for_file: avoid_print, prefer_final_fields, sized_box_for_whitespace, must_be_immutable, prefer_const_constructors

import 'dart:io';

import 'package:demo_chat_app/bloc/login/login_bloc.dart';
import 'package:demo_chat_app/page/home/home_page.dart';
import 'package:demo_chat_app/widget/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserName extends StatefulWidget {
  const UserName({Key? key, required this.pass}) : super(key: key);
  final String pass;

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
          create: (context) => LoginBloc(),
          child: WireFrameUserName(pass: widget.pass)),
    );
  }
}

class WireFrameUserName extends StatefulWidget {
  const WireFrameUserName({Key? key, required this.pass}) : super(key: key);
  final String pass;

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
            Get.bottomSheet(
                buildImagePicker(
                    context: context,
                    onTapCamera: () {
                      Get.back();
                      _saveImage(ImageSource.camera);
                    },
                    onTapGallery: () {
                      Get.back();
                      _saveImage(ImageSource.gallery);
                    }),
                backgroundColor: Colors.white);
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
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            AppLocalizations.of(context)!.enter_your_name,
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
                  hintText: AppLocalizations.of(context)!.your_name),
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
                    AppLocalizations.of(context)!.conti,
                    style: TextStyle(fontSize: 15),
                  ),
                );
              },
            ),
            onPressed: () {
              if (_nameController.text == '' || _nameController.text.isEmpty) {
                Get.defaultDialog(
                  title: '',
                  content: Text(
                      AppLocalizations.of(context)!.please_enter_enough_info),
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
                print(_nameController.text);
                print(avatar);
                user.updateDisplayName(_nameController.text);
                user.updatePhotoURL(avatar);

                loginBloc.add(CreateUserEvent(
                    _nameController.text, avatar, user.uid, widget.pass));

                Get.to(const HomePage());
              }
            }),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF08C187),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                AppLocalizations.of(context)!.exit,
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
