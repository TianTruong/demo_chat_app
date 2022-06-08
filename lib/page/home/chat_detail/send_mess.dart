// ignore_for_file: prefer_typing_uninitialized_variables, prefer_final_fields, avoid_print, sized_box_for_whitespace, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';

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
  bool _isRecording = false;
  final _audioRecorder = Record();

  send(message, ImageURL, VoiceURL) {
    chats.doc(widget.chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'friendUid': widget.friendUid,
      'friendName': widget.friendName,
      'message': message,
      'image': ImageURL,
      'voice': VoiceURL,
      'uid': currentUserId
    }).then((value) {
      _textController.text = '';
    });
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();

        bool isRecording = await _audioRecorder.isRecording();
        setState(() {
          _isRecording = isRecording;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stop() async {
    final AudioID = DateTime.now().microsecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(widget.chatDocId)
        .child('/audio')
        .child('Audio_$AudioID');

    final path = await _audioRecorder.stop();

    var audio = File(path!);

    await ref.putFile(audio);

    var AudioURL = await ref.getDownloadURL();

    send('', '', AudioURL);

    setState(() => _isRecording = false);
  }

  void sendMessage(String message) {
    if (message == '') return;
    send(message, '', '');
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

    var ImageURL = await ref.getDownloadURL();

    print(ImageURL);

    send('', ImageURL, '');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Nút chọn hình ảnh
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
          // Nút gửi voice
          _isRecording
              ? Row(
                  children: [
                    IconButton(
                        color: Colors.redAccent,
                        icon: const Icon(
                          Icons.delete,
                          size: 30,
                        ),
                        onPressed: () => {
                              _audioRecorder.stop(),
                              setState(() => _isRecording = false)
                            }),
                    IconButton(
                        color: Colors.redAccent,
                        icon: const Icon(
                          Icons.send_sharp,
                          size: 30,
                        ),
                        onPressed: () => {_stop()}),
                  ],
                )
              : IconButton(
                  color: const Color(0xFF08C187),
                  icon: const Icon(
                    Icons.mic,
                    size: 35,
                  ),
                  onPressed: () => {_start(), _isRecording = true}),
          // Nhập nội dung tin nhắn
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
          // Nút gửi tin nhắn
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