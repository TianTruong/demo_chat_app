import 'package:demo_chat_app/page/home/chat_detail/chat_detail.dart';
import 'package:demo_chat_app/state/chat_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:demo_chat_app/model/firstmessage.dart';

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
                  FirstMessage firstMessage = FirstMessage();
                  firstMessage = firstMessage.map(data);

                  return Card(
                    child: ListTile(
                        title: Text(firstMessage.friendName),
                        subtitle: Text(firstMessage.message),
                        trailing: const Icon(Icons.arrow_forward_ios_outlined),
                        onTap: () => firstMessage.friendUid != currentUserId
                            ? callChatDetailScreen(context,
                                firstMessage.friendName, firstMessage.friendUid)
                            : callChatDetailScreen(context,
                                firstMessage.friendName, firstMessage.uid)),
                  );
                }).toList()))
              ],
            ));
  }
}
