// ignore_for_file: avoid_print

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<CreateUserEvent>(_onCreateUserEvent);
    on<SaveImageEvent>(_onSaveImageEvent);
  }

  Future<void> _onCreateUserEvent(
      CreateUserEvent event, Emitter<LoginState> emit) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    await users
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .limit(1)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          users.add({
            'name': event.name,
            'avatar': event.avatar,
            'status': 'Available',
            'uid': event.uid,
            'password': event.pass
          });
        }
      },
    ).catchError((error) {});

    emit(state);
  }

  Future<void> _onSaveImageEvent(
      SaveImageEvent event, Emitter<LoginState> emit) async {
    final user = FirebaseAuth.instance.currentUser!;

    final ImagePicker _picker = ImagePicker();

    Reference ref = FirebaseStorage.instance.ref().child('avatar/${user.uid}');

    final XFile? image = await _picker.pickImage(source: event.source);

    var img = File(image!.path);

    await ref.putFile(img);

    var downloadURL = await ref.getDownloadURL();

    print(downloadURL);

    emit(state);
  }
}
