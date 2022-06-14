// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';

class FirstMessage {
  final friendName;
  final friendUid;
  final message;
  final uid;

  FirstMessage({
    this.friendName,
    this.friendUid,
    this.message,
    this.uid,
  });

  factory FirstMessage.fromJson(Map<String, dynamic> data) {
    return FirstMessage(
      friendName: data["friendName"],
      friendUid: data["friendUid"],
      message: data["message"],
      uid: data["uid"],
    );
  }

  factory FirstMessage.fromSnapshot(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data()! as Map<String, dynamic>;
    return FirstMessage(
      friendName: data["friendName"],
      friendUid: data["friendUid"],
      message: data["message"],
      uid: data["uid"],
    );
  }

  Map<String, dynamic> toMap(FirstMessage messages) {
    return {
      "friendName": friendName,
      "friendUid": friendUid,
      "message": message,
      "uid": uid,
    };
  }

  FirstMessage map(dynamic data) {
    return FirstMessage(
      friendName: data['friendName'],
      friendUid: data['friendUid'],
      message: data['message'],
      uid: data['uid'],
    );
  }
}
