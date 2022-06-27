import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_chat_app/bloc/check/check_bloc.dart';
import 'package:demo_chat_app/model/users.dart';
import 'package:demo_chat_app/page/home/chat_detail/chat_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class People extends StatefulWidget {
  const People(this.SetChat, {Key? key}) : super(key: key);
  final void Function(String friendUid, String friendName) SetChat;

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  var currentUser = FirebaseAuth.instance.currentUser!.uid;

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
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('uid', isNotEqualTo: currentUser)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong.');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading');
              }

              if (snapshot.hasData) {
                return CustomScrollView(
                  slivers: [
                    CupertinoSliverNavigationBar(
                      automaticallyImplyLeading: false,
                      largeTitle: Text(AppLocalizations.of(context)!.people),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        snapshot.data!.docs.map(
                          (DocumentSnapshot document) {
                            // Map<String, dynamic> data =
                            //     document.data() as Map<String, dynamic>;

                            Users users = Users();
                            users = users.map(document.data());

                            return Card(
                              child: ListTile(
                                onTap: () async {
                                  MediaQuery.of(context).size.width < 600
                                      ? callChatDetailScreen(
                                          context, users.name, users.uid)
                                      : {
                                          context.read<CheckBloc>().add(
                                              SetChatDocIdEvent(
                                                  users.uid, users.name)),
                                          widget.SetChat(users.uid, users.name),
                                        };
                                },
                                leading: users.avatar != ''
                                    ? ClipOval(
                                        child: Image.network(
                                          users.avatar,
                                          fit: BoxFit.cover,
                                          cacheHeight: 160,
                                          cacheWidth: 160,
                                        ),
                                      )
                                    : ClipOval(
                                        child: Image.asset(
                                          'images/bg.jpg',
                                          fit: BoxFit.fill,
                                          cacheHeight: 160,
                                          cacheWidth: 160,
                                        ),
                                      ),
                                title: Text(users.name),
                                subtitle: Text(users.status),
                                trailing: const Icon(
                                    Icons.arrow_forward_ios_outlined),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    )
                  ],
                );
              }
              return Container();
            }));
  }
}
