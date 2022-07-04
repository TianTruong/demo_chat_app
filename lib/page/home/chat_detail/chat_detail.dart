// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, prefer_final_fields, no_logic_in_create_state, non_constant_identifier_names, sized_box_for_whitespace, prefer_const_constructors_in_immutables, unused_field, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_chat_app/bloc/send/send_bloc.dart';
import 'package:demo_chat_app/model/messages.dart';
import 'package:demo_chat_app/page/home/chat_detail/display_mess.dart';
import 'package:demo_chat_app/page/home/chat_detail/send_mess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetail extends StatefulWidget {
  const ChatDetail(
      {Key? key, required this.chatDocId, this.friendUid, this.friendName})
      : super(key: key);
  final String chatDocId;
  final friendUid;
  final friendName;

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  var _textController = TextEditingController();

  @override
  void initState() {
    debugPrint('------------------------Start----------------------');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('------------------------Check----------------------');

    return StreamBuilder<QuerySnapshot>(
      stream: chats
          .doc(widget.chatDocId)
          .collection('messages')
          .orderBy('createdOn', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading:
                  MediaQuery.of(context).size.width < 600 ? true : false,
              backgroundColor: Color(0xFF08C187),
              title: Text(widget.friendName),
              centerTitle: true,
              actions: [IconButton(onPressed: () {}, icon: Icon(Icons.phone))],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      reverse: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Messages mes = Messages();
                        mes = mes.map(document.data());

                        return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: displayMessWidget(
                                mes: mes, friendUid: widget.friendUid));
                      }).toList(),
                    ),
                  ),
                  SendMessageWidget(
                      chatDocId: widget.chatDocId,
                      friendUid: widget.friendUid,
                      friendName: widget.friendName)
                ],
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
