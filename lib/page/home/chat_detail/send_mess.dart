// ignore_for_file: prefer_typing_uninitialized_variables, prefer_final_fields, avoid_print, sized_box_for_whitespace, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_chat_app/widget/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:demo_chat_app/controllers/sendMess_controllers.dart';

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
  TextEditingController _textController = TextEditingController();
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  bool _isRecording = false;
  final _audioRecorder = Record();

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

  @override
  Widget build(BuildContext context) {
    final sendController = Get.put(SendMessController());
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
                    Get.bottomSheet(
                        buildImagePicker(
                            context: context,
                            onTapCamera: () {
                              Get.back();

                              sendController.sendImageEvent(
                                  source: ImageSource.camera,
                                  chatDocId: widget.chatDocId,
                                  friendUid: widget.friendUid,
                                  friendName: widget.friendName);
                            },
                            onTapGallery: () {
                              Get.back();

                              sendController.sendImageEvent(
                                  source: ImageSource.gallery,
                                  chatDocId: widget.chatDocId,
                                  friendUid: widget.friendUid,
                                  friendName: widget.friendName);
                            }),
                        backgroundColor: Colors.white)

                    // showModalBottomSheet(
                    //     context: context,
                    //     builder: (context) => buildImagePicker(
                    //         context: context,
                    //         onTapCamera: () {
                    //           Get.back();

                    //           sendController.sendImageEvent(
                    //               source: ImageSource.camera,
                    //               chatDocId: widget.chatDocId,
                    //               friendUid: widget.friendUid,
                    //               friendName: widget.friendName);
                    //         },
                    //         onTapGallery: () {
                    //           Get.back();

                    //           sendController.sendImageEvent(
                    //               source: ImageSource.gallery,
                    //               chatDocId: widget.chatDocId,
                    //               friendUid: widget.friendUid,
                    //               friendName: widget.friendName);
                    //         }))
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
                        onPressed: () => {
                              sendController.sendVoiceEvent(
                                  record: _audioRecorder,
                                  chatDocId: widget.chatDocId,
                                  friendUid: widget.friendUid,
                                  friendName: widget.friendName),
                              _isRecording = false
                            }),
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
                hintText: AppLocalizations.of(context)!.enter_a_message,
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
              onPressed: () => {
                    sendController.sendMessEvent(
                        message: _textController.text,
                        chatDocId: widget.chatDocId,
                        friendUid: widget.friendUid,
                        friendName: widget.friendName),
                    _textController.clear()
                  })
        ],
      ),
    );
  }
}
