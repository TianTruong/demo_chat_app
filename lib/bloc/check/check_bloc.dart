// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'check_event.dart';
part 'check_state.dart';

class CheckBloc extends Bloc<CheckEvent, CheckState> {
  CheckBloc() : super(CheckState()) {
    on<SetChatDocIdEvent>(_onCreateUserEvent);
  }

  void _onCreateUserEvent(
      SetChatDocIdEvent event, Emitter<CheckState> emit) async {
    emit(CleanChatIdState());
    CollectionReference chats = FirebaseFirestore.instance.collection('chats');
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    String chatDocId = '';

    await chats
        .where('users', isEqualTo: {event.friendUid: null, currentUserId: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            if (querySnapshot.docs.isNotEmpty) {
              chatDocId = querySnapshot.docs.single.id;
              print(chatDocId);
            } else {
              await chats
                  .add({
                    'users': {currentUserId: null, event.friendUid: null},
                    'names': {
                      currentUserId:
                          FirebaseAuth.instance.currentUser?.displayName,
                      event.friendUid: event.friendName
                    }
                  })
                  .then((value) => {chatDocId = value.id})
                  .whenComplete(() => print(chatDocId));
            }
          },
        )
        .catchError((error) {});

    emit(SetChatDocIdState(ChatDocID: chatDocId, friendUid: event.friendUid, friendName: event.friendName));
  }
}
