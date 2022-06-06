import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_chat_app/page/home/chat_detail/chat_detail.dart';
import 'package:demo_chat_app/state/chat_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  var chatState = ChatState();
  @override
  void initState() {
    super.initState();
    chatState.refreshChatsForCurrentUser();
  }

  void callChatDetailScreen(BuildContext context, String name, String uid) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatDetail(
                  friendName: name,
                  friendUid: uid,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (BuildContext context) => CustomScrollView(
              slivers: [
                const CupertinoSliverNavigationBar(
                  automaticallyImplyLeading: false,
                  largeTitle: Text("Chats"),
                ),
                SliverList(
                    delegate: SliverChildListDelegate(
                        chatState.messages.values.toList().map((data) {
                  return Card(
                    child: ListTile(
                        // leading: data['avatar'] != ''
                        //               ? ClipOval(
                        //                   child: Image.network(
                        //                     data['avatar'],
                        //                     fit: BoxFit.cover,
                        //                     cacheHeight: 160,
                        //                     cacheWidth: 160,
                        //                   ),
                        //                 )
                        //               : ClipOval(
                        //                   child: Image.asset(
                        //                     'images/bg.jpg',
                        //                     fit: BoxFit.fill,
                        //                     cacheHeight: 160,
                        //                     cacheWidth: 160,
                        //                   ),
                        //                 ),
                        title: Text(data['friendName']),
                        subtitle: Text(data['message']),
                        trailing: const Icon(Icons.arrow_forward_ios_outlined),
                        onTap: () => data['friendUid'] != currentUserId
                            ? callChatDetailScreen(
                                context, data['friendName'], data['friendUid'])
                            : callChatDetailScreen(
                                context, data['friendName'], data['uid'])),
                  );
                }).toList()))
              ],
            ));
  }
}
