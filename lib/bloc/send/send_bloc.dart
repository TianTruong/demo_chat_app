// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:record/record.dart';

part 'send_event.dart';
part 'send_state.dart';

class SendBloc extends Bloc<SendEvent, SendState> {
  SendBloc() : super(SendState()) {
    on<SendMessEvent>(_onSendMessEvent);
    on<SendImageEvent>(_onSendImageEvent);
    on<SendVoiceEvent>(_onSendVoiceEvent);
  }

  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> _onSendMessEvent(
      SendMessEvent event, Emitter<SendState> emit) async {
    if (event.message == '') return;
    chats.doc(event.chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'friendUid': event.friendUid,
      'friendName': event.friendName,
      'message': event.message,
      'image': '',
      'voice': '',
      'uid': currentUserId
    }).then((value) {});

    emit(state);
  }

  Future<void> _onSendImageEvent(
      SendImageEvent event, Emitter<SendState> emit) async {
    final ImageID = DateTime.now().microsecondsSinceEpoch.toString();
    final ImagePicker _picker = ImagePicker();

    Reference ref = FirebaseStorage.instance
        .ref()
        .child(event.chatDocId)
        .child('/images')
        .child('Image_$ImageID');

    final XFile? image = await _picker.pickImage(source: event.source);

    var img = File(image!.path);

    await ref.putFile(img);

    var ImageURL = await ref.getDownloadURL();

    print(ImageURL);

    chats.doc(event.chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'friendUid': event.friendUid,
      'friendName': event.friendName,
      'message': '',
      'image': ImageURL,
      'voice': '',
      'uid': currentUserId
    }).then((value) {});

    emit(state);
  }

  Future<void> _onSendVoiceEvent(
      SendVoiceEvent event, Emitter<SendState> emit) async {
    final VoiceID = DateTime.now().microsecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(event.chatDocId)
        .child('/voice')
        .child('Voice_$VoiceID');

    final path = await event.record.stop();

    var audio = File(path!);

    await ref.putFile(audio);

    var VoiceURL = await ref.getDownloadURL();

    print(VoiceURL);

    chats.doc(event.chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'friendUid': event.friendUid,
      'friendName': event.friendName,
      'message': '',
      'image': '',
      'voice': VoiceURL,
      'uid': currentUserId
    }).then((value) {});

    emit(state);
  }
}
