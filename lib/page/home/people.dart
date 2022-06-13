import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_chat_app/model/model.dart';
import 'package:demo_chat_app/page/home/chat_detail/chat_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class People extends StatefulWidget {
  const People({Key? key}) : super(key: key);

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
                    const CupertinoSliverNavigationBar(
                      automaticallyImplyLeading: false,
                      largeTitle: Text("People"),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        snapshot.data!.docs.map(
                          (DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            Users users = Users(
                              avatar: data['avatar'],
                              name: data['name'],
                              status: data['status'],
                              uid: data['uid'],
                            );

                            return Card(
                              child: ListTile(
                                onTap: () => callChatDetailScreen(
                                    context, users.name, users.uid),
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
