import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_chat_app/bloc/check/check_bloc.dart';
import 'package:demo_chat_app/model/users.dart';
import 'package:demo_chat_app/widget/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class People extends StatefulWidget {
  const People({Key? key}) : super(key: key);

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  var currentUser = FirebaseAuth.instance.currentUser!.uid;

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
                return const Center(child: Text('Something went wrong.'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
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

                            return buildPeople(
                                avatar: users.avatar,
                                name: users.name,
                                status: users.status,
                                onTap: () async {
                                  context.read<CheckBloc>().add(
                                      SetChatDocIdEvent(users.uid, users.name));
                                });
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
