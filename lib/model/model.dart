// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String avatar;
  final String name;
  final String status;
  final String uid;

  Users({
    required this.avatar,
    required this.name,
    required this.status,
    required this.uid,
  });
}

class Messages {
  final createdOn;
  final friendName;
  final friendUid;
  final image;
  final message;
  final voice;
  final uid;

  Messages(
      {required this.createdOn,
      required this.friendName,
      required this.friendUid,
      required this.image,
      required this.message,
      required this.voice,
      required this.uid});

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
}
