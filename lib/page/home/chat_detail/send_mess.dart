// ignore_for_file: prefer_typing_uninitialized_variables, prefer_final_fields, avoid_print, sized_box_for_whitespace, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SendMessageWidget extends StatefulWidget {
  final chatDocId;
  final friendUid;
  final friendName;
  const SendMessageWidget(
      {Key? key, this.chatDocId, this.friendName, this.friendUid})
      : super(key: key);

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  var _textController = TextEditingController();
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  void sendMessage(String message) {
    if (message == '') return;
    chats.doc(widget.chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'friendUid': 
      // currentUserId,
      widget.friendUid,
      'friendName': widget.friendName,
      'message': message,
      'image': '',
      'uid':currentUserId
    }).then((value) {
      _textController.text = '';
    });
  }

  void sendImage(ImageSource source) async {
    final ImageID = DateTime.now().microsecondsSinceEpoch.toString();
    final ImagePicker _picker = ImagePicker();

    Reference ref = FirebaseStorage.instance
        .ref()
        .child(widget.chatDocId)
        .child('/images')
        .child('Image_$ImageID');

    final XFile? image = await _picker.pickImage(source: source);

    var img = File(image!.path);

    await ref.putFile(img);

    var downloadURL = await ref.getDownloadURL();

    print(downloadURL);

    chats.doc(widget.chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'friendUid': widget.friendUid,
      'friendName': widget.friendName,
      'message': '',
      'image': downloadURL,
      'uid':currentUserId
    }).then((value) {
      _textController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              color: const Color(0xFF08C187),
              icon: const Icon(
                Icons.image,
                size: 35,
              ),
              onPressed: () => {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                            height: 150,
                            child: Column(children: [
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('Camera'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  sendImage(ImageSource.camera);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.image),
                                title: const Text('Gallery'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  sendImage(ImageSource.gallery);
                                },
                              )
                            ])))
                  }),
          IconButton(
              color: const Color(0xFF08C187),
              icon: const Icon(
                Icons.mic,
                size: 35,
              ),
              onPressed: () => {}),
          Expanded(
            child: TextField(
              cursorColor: const Color(0xFF08C187),
              keyboardType: TextInputType.text,
              controller: _textController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: Color(0xFF08C187), width: 3)),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(color: Color(0xFF08C187), width: 3),
                ),
                hintText: 'Nhập tin nhắn ...',
                // labelText: 'Name'
              ),
            ),
          ),
          IconButton(
              color: const Color(0xFF08C187),
              icon: const Icon(
                Icons.send_sharp,
                size: 35,
              ),
              onPressed: () => sendMessage(_textController.text))
        ],
      ),
    );
  }
}
