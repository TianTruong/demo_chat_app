// ignore_for_file: prefer_typing_uninitialized_variables, prefer_final_fields, avoid_print, sized_box_for_whitespace, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_chat_app/bloc/send/send_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final sendBloc = BlocProvider.of<SendBloc>(context);
    
    return BlocBuilder<SendBloc, SendState>(
      builder: (context, state) {
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
                                    title: Text(
                                        AppLocalizations.of(context)!.camera),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      sendBloc.add(SendImageEvent(
                                          widget.chatDocId,
                                          widget.friendUid,
                                          widget.friendName,
                                          ImageSource.camera));
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.image),
                                    title: Text(
                                        AppLocalizations.of(context)!.gallery),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      sendBloc.add(SendImageEvent(
                                          widget.chatDocId,
                                          widget.friendUid,
                                          widget.friendName,
                                          ImageSource.gallery));
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
                            onPressed: () => {
                                  sendBloc.add(SendVoiceEvent(
                                      widget.chatDocId,
                                      widget.friendUid,
                                      widget.friendName,
                                      _audioRecorder)),
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
                        borderSide: const BorderSide(
                            color: Color(0xFF08C187), width: 3)),

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
                  onPressed: () => {
                        sendBloc.add(SendMessEvent(
                            widget.chatDocId,
                            widget.friendUid,
                            widget.friendName,
                            _textController.text)),
                        _textController.clear()
                      })
            ],
          ),
        );
      },
    );
  }
}
