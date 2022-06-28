// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, prefer_final_fields, no_logic_in_create_state, non_constant_identifier_names, sized_box_for_whitespace, prefer_const_constructors_in_immutables, unused_field, curly_braces_in_flow_control_structures

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:demo_chat_app/bloc/check/check_bloc.dart';
// import 'package:demo_chat_app/bloc/send/send_bloc.dart';
// import 'package:demo_chat_app/page/home/chat_detail/display_mess.dart';
// import 'package:demo_chat_app/page/home/chat_detail/send_mess.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ChatDetail extends StatefulWidget {
//   ChatDetail({Key? key, this.friendUid, this.friendName}) : super(key: key);
//   final friendUid;
//   final friendName;

//   @override
//   _ChatDetailState createState() => _ChatDetailState();
// }

// class _ChatDetailState extends State<ChatDetail> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (context) => CheckBloc(),
//         child:
//             Demo(friendName: widget.friendName, friendUid: widget.friendUid));
//   }
// }

// class Demo extends StatefulWidget {
//   const Demo({Key? key, this.friendUid, this.friendName}) : super(key: key);
//   final friendUid;
//   final friendName;

//   @override
//   State<Demo> createState() => _DemoState();
// }

// class _DemoState extends State<Demo> {
//   CollectionReference chats = FirebaseFirestore.instance.collection('chats');
//   var _textController = TextEditingController();
//   String? abc;

//   @override
//   Widget build(BuildContext context) {
//     final checkBloc = BlocProvider.of<CheckBloc>(context);
//     return BlocBuilder<CheckBloc, CheckState>(
//       builder: (context, state) {
//         if (abc == null)
//           checkBloc.add(SetChatDocIdEvent(widget.friendUid, widget.friendName));

//         return BlocListener<CheckBloc, CheckState>(
//           listener: (context, state) {
//             if (state is SetChatDocIdState) abc = state.ChatDocID;
//           },
//           child: StreamBuilder<QuerySnapshot>(
//             stream: chats
//                 .doc(abc)
//                 .collection('messages')
//                 .orderBy('createdOn', descending: true)
//                 .snapshots(),
//             builder:
//                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (snapshot.hasError) {
//                 return Center(
//                   child: Text("Something went wrong"),
//                 );
//               }

//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Scaffold(
//                   body: Center(
//                     child: Text("Loading"),
//                   ),
//                 );
//               }

//               if (snapshot.hasData) {
//                 var data;
//                 return Scaffold(
//                   appBar: AppBar(
//                     automaticallyImplyLeading:
//                         MediaQuery.of(context).size.width < 600 ? true : false,
//                     backgroundColor: Color(0xFF08C187),
//                     title: Text(widget.friendName),
//                     centerTitle: true,
//                     actions: [
//                       IconButton(onPressed: () {}, icon: Icon(Icons.phone))
//                     ],
//                   ),
//                   body: MultiBlocProvider(
//                     providers: [
//                       BlocProvider(
//                         create: (context) => SendBloc(),
//                       ),
//                     ],
//                     child: SafeArea(
//                       child: Column(
//                         children: [
//                           Expanded(
//                             child: ListView(
//                               reverse: true,
//                               children: snapshot.data!.docs.map(
//                                 (DocumentSnapshot document) {
//                                   data = document.data()!;
//                                   // print(document.toString());
//                                   // print(data['message']);
//                                   return Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 8.0),
//                                       child: displayMessWidget(
//                                           data: data,
//                                           friendUid: widget.friendUid));
//                                 },
//                               ).toList(),
//                             ),
//                           ),
//                           SendMessageWidget(
//                               chatDocId: abc,
//                               friendUid: widget.friendUid,
//                               friendName: widget.friendName)
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               } else {
//                 return Container();
//               }
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, prefer_final_fields, no_logic_in_create_state, non_constant_identifier_names, sized_box_for_whitespace, prefer_const_constructors_in_immutables, unused_field, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_chat_app/bloc/check/check_bloc.dart';
import 'package:demo_chat_app/bloc/send/send_bloc.dart';
import 'package:demo_chat_app/page/home/chat_detail/display_mess.dart';
import 'package:demo_chat_app/page/home/chat_detail/send_mess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class ChatDetail extends StatefulWidget {
//   ChatDetail({Key? key, this.friendUid, this.friendName}) : super(key: key);
//   final friendUid;
//   final friendName;

//   @override
//   _ChatDetailState createState() => _ChatDetailState();
// }

// class _ChatDetailState extends State<ChatDetail> {
//   @override
//   Widget build(BuildContext context) {
//     // if (MediaQuery.of(context).size.width < 600) {
//     //   return BlocProvider(
//     //     create: (context) => CheckBloc(),
//     //     child: Demo(friendName: widget.friendName, friendUid: widget.friendUid),
//     //   );
//     // } else {
//     //   return Demo(friendName: widget.friendName, friendUid: widget.friendUid);
//     // }

//       return Demo(friendName: widget.friendName, friendUid: widget.friendUid);

//   }
// }

class ChatDetail extends StatefulWidget {
  const ChatDetail({Key? key, this.friendUid, this.friendName})
      : super(key: key);
  final friendUid;
  final friendName;

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  var _textController = TextEditingController();
  String? chatDocId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckBloc, CheckState>(
      builder: (context, state) {
        if (MediaQuery.of(context).size.width < 600 && chatDocId == null)
          context
              .read<CheckBloc>()
              .add(SetChatDocIdEvent(widget.friendUid, widget.friendName));

        return BlocListener<CheckBloc, CheckState>(
          listener: (context, state) {
            if (state is SetChatDocIdState) chatDocId = state.ChatDocID;
          },
          child: StreamBuilder<QuerySnapshot>(
            stream: chats
                .doc(chatDocId)
                .collection('messages')
                .orderBy('createdOn', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    automaticallyImplyLeading:
                        MediaQuery.of(context).size.width < 600 ? true : false,
                    backgroundColor: Color(0xFF08C187),
                    title: Text(widget.friendName),
                    centerTitle: true,
                    actions: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.phone))
                    ],
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
                                  // print(document.toString());
                                  // print(data['message']);
                                  return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: displayMessWidget(
                                          data: data,
                                          friendUid: widget.friendUid));
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
          ),
        );
      },
    );
  }
}
