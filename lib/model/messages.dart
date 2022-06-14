// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  final createdOn;
  final friendName;
  final friendUid;
  final image;
  final message;
  final voice;
  final uid;

  Messages({
    this.createdOn,
    this.friendName,
    this.friendUid,
    this.image,
    this.message,
    this.voice,
    this.uid,
  });

  factory Messages.fromJson(Map<String, dynamic> data) {
    return Messages(
      createdOn: data["createdOn"],
      friendName: data["friendName"],
      friendUid: data["friendUid"],
      image: data["image"],
      message: data["message"],
      voice: data["voice"],
      uid: data["uid"],
    );
  }

  factory Messages.fromSnapshot(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data()! as Map<String, dynamic>;
    return Messages(
      createdOn: data["createdOn"],
      friendName: data["friendName"],
      friendUid: data["friendUid"],
      image: data["image"],
      message: data["message"],
      voice: data["voice"],
      uid: data["uid"],
    );
  }

  Map<String, dynamic> toMap(Messages messages) {
    return {
      "createdOn": createdOn,
      "friendName": friendName,
      "friendUid": friendUid,
      "image": image,
      "message": message,
      "voice": voice,
      "uid": uid,
    };
  }

  Messages map(dynamic data) {
    return Messages(
      createdOn: data['createdOn'],
      friendName: data['friendName'],
      friendUid: data['friendUid'],
      image: data['image'],
      message: data['message'],
      voice: data['voice'],
      uid: data['uid'],
    );
  }
}
