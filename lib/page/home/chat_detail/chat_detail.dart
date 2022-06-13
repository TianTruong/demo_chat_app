// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, prefer_final_fields, no_logic_in_create_state, non_constant_identifier_names, sized_box_for_whitespace, prefer_const_constructors_in_immutables, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_chat_app/bloc/send/send_bloc.dart';
import 'package:demo_chat_app/model/model.dart';
import 'package:demo_chat_app/page/home/chat_detail/display_mess.dart';
import 'package:demo_chat_app/page/home/chat_detail/send_mess.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetail extends StatefulWidget {
  final friendUid;
  final friendName;

  ChatDetail({Key? key, this.friendUid, this.friendName}) : super(key: key);

  @override
  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  var chatDocId;
  var _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    await chats
        .where('users',
            isEqualTo: {widget.friendUid: null, currentUserId: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            print(currentUserId);
            print(widget.friendUid);
            print(widget.friendName);
            if (querySnapshot.docs.isNotEmpty) {
              setState(() {
                chatDocId = querySnapshot.docs.single.id;
              });

              print(chatDocId);
            } else {
              await chats
                  .add({
                    'users': {currentUserId: null, widget.friendUid: null},
                    'names': {
                      currentUserId:
                          FirebaseAuth.instance.currentUser?.displayName,
                      widget.friendUid: widget.friendName
                    }
                  })
                  .then((value) => {chatDocId = value.id})
                  .whenComplete(() => print(chatDocId));
              setState(() {});
            }
          },
        )
        .catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chats
          .doc(chatDocId)
          .collection('messages')
          .orderBy('createdOn', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Text("Loading"),
            ),
          );
        }

        if (snapshot.hasData) {
          var data;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF08C187),
              title: Text(widget.friendName),
              centerTitle: true,
              actions: [IconButton(onPressed: () {}, icon: Icon(Icons.phone))],
            ),
            body: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SendBloc(),
                ),
              ],
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        reverse: true,
                        children: snapshot.data!.docs.map(
                          (DocumentSnapshot document) {
                            data = document.data()!;
                            print(document.toString());
                            print(data['message']);
                            return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: displayMessWidget(
                                    data: data, friendUid: widget.friendUid));
                          },
                        ).toList(),
                      ),
                    ),
                    SendMessageWidget(
                        chatDocId: chatDocId,
                        friendUid: widget.friendUid,
                        friendName: widget.friendName)
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
