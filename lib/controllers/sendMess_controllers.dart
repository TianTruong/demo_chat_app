import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SendMessController extends GetxController {
  
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  sendMessEvent(
      {@required message,
      @required friendUid,
      @required friendName,
      @required chatDocId}) async {
    if (message == '') return;
    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'friendUid': friendUid,
      'friendName': friendName,
      'message': message,
      'image': '',
      'voice': '',
      'uid': currentUserId
    }).then((value) {});
  }

  sendImageEvent(
      {@required source,
      @required friendUid,
      @required friendName,
      @required chatDocId}) async {
    final ImageID = DateTime.now().microsecondsSinceEpoch.toString();
    final ImagePicker _picker = ImagePicker();

    Reference ref = FirebaseStorage.instance
        .ref()
        .child(chatDocId)
        .child('/images')
        .child('Image_$ImageID');

    final XFile? image = await _picker.pickImage(source: source);

    var img = File(image!.path);

    await ref.putFile(img);

    var ImageURL = await ref.getDownloadURL();

    print(ImageURL);

    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'friendUid': friendUid,
      'friendName': friendName,
      'message': '',
      'image': ImageURL,
      'voice': '',
      'uid': currentUserId
    }).then((value) {});
  }

  sendVoiceEvent(
      {@required record,
      @required friendUid,
      @required friendName,
      @required chatDocId}) async {
    final VoiceID = DateTime.now().microsecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(chatDocId)
        .child('/voice')
        .child('Voice_$VoiceID');

    final path = await record.stop();

    var audio = File(path!);

    await ref.putFile(audio);

    var VoiceURL = await ref.getDownloadURL();

    print(VoiceURL);

    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'friendUid': friendUid,
      'friendName': friendName,
      'message': '',
      'image': '',
      'voice': VoiceURL,
      'uid': currentUserId
    }).then((value) {});
  }
}
