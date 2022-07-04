import 'package:demo_chat_app/bloc/check/check_bloc.dart';
import 'package:demo_chat_app/model/firstmessage.dart';
import 'package:demo_chat_app/page/home/chat_detail/chat_detail.dart';
import 'package:demo_chat_app/state/chat_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckBloc, CheckState>(
      builder: (context, state) {
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Observer(
                  builder: (BuildContext context) => CustomScrollView(
                        slivers: [
                          CupertinoSliverNavigationBar(
                            automaticallyImplyLeading: false,
                            largeTitle:
                                Text(AppLocalizations.of(context)!.chat),
                          ),
                          SliverList(
                              delegate: SliverChildListDelegate(chatState
                                  .messages.values
                                  .toList()
                                  .map((data) {
                            FirstMessage firstMessage = FirstMessage();
                            firstMessage = firstMessage.map(data);

                            return Card(
                              child: ListTile(
                                  title: Text(firstMessage.friendName),
                                  subtitle: Text(firstMessage.message),
                                  trailing: const Icon(
                                      Icons.arrow_forward_ios_outlined),
                                  onTap: () =>
                                      firstMessage.friendUid != currentUserId
                                          ? {
                                              context.read<CheckBloc>().add(
                                                  SetChatDocIdEvent(
                                                      firstMessage.friendUid,
                                                      firstMessage.friendName)),
                                            }
                                          : {
                                              context.read<CheckBloc>().add(
                                                  SetChatDocIdEvent(
                                                      firstMessage.uid,
                                                      firstMessage.friendName)),
                                            }),
                            );
                          }).toList()))
                        ],
                      ));
            },
          ),
        );
      },
    );
    Size screenSize = MediaQuery.of(context).size;

    return Observer(
        builder: (BuildContext context) => CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  automaticallyImplyLeading: false,
                  largeTitle: Text(AppLocalizations.of(context)!.chat),
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
                            ? {
                                context.read<CheckBloc>().add(SetChatDocIdEvent(
                                    firstMessage.friendUid,
                                    firstMessage.friendName)),
                              }
                            : {
                                context.read<CheckBloc>().add(SetChatDocIdEvent(
                                    firstMessage.uid, firstMessage.friendName)),
                              }),
                  );
                }).toList()))
              ],
            ));
  }
}
