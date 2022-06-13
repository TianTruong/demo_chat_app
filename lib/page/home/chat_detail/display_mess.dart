// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, prefer_const_constructors, sized_box_for_whitespace, avoid_print

import 'package:demo_chat_app/model/model.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';

class displayMessWidget extends StatefulWidget {
  final data;
  final String friendUid;
  const displayMessWidget({Key? key, this.data, required this.friendUid})
      : super(key: key);

  @override
  State<displayMessWidget> createState() => _displayMessWidgetState();
}

class _displayMessWidgetState extends State<displayMessWidget> {
  AudioPlayer advancedPlayer = AudioPlayer();
  String path =
      'https://firebasestorage.googleapis.com/v0/b/chatapp-ef0a7.appspot.com/o/sample-6s.mp3?alt=media&token=6afbc658-2733-45f4-be07-53a212211ce1';
  late Messages mes;

  @override
  void initState() {
    mes = Messages(
      createdOn: widget.data['createdOn'],
      friendName: widget.data['friendName'],
      friendUid: widget.data['friendUid'],
      image: widget.data['image'],
      message: widget.data['message'],
      voice: widget.data['voice'],
      uid: widget.data['uid'],
    );
    super.initState();
  }

  bool isSender(String friend) {
    return friend != widget.friendUid;
  }

  Alignment getAlignment(friend) {
    if (friend != widget.friendUid) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  buildButton(data) {
    return advancedPlayer.state == PlayerState.STOPPED ||
            advancedPlayer.state == PlayerState.COMPLETED
        ? IconButton(
            color: Colors.black,
            icon: Icon(Icons.play_arrow),
            onPressed: () async {
              // await advancedPlayer.play(data);
              await advancedPlayer.play(path);
              setState(() {});
            },
          )
        : advancedPlayer.state == PlayerState.PAUSED
            ? IconButton(
                color: Colors.black,
                icon: Icon(Icons.play_arrow),
                onPressed: () async {
                  await advancedPlayer.resume();
                  setState(() {});
                },
              )
            : IconButton(
                color: Colors.black,
                icon: Icon(Icons.pause),
                onPressed: () async {
                  await advancedPlayer.pause().whenComplete(
                      () => advancedPlayer.state = PlayerState.PAUSED);
                  setState(() {});
                },
              );
  }

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      clipper: ChatBubbleClipper6(
        nipSize: 5,
        radius: 15,
        type: isSender(mes.uid.toString())
            ? BubbleType.sendBubble
            : BubbleType.receiverBubble,
      ),
      alignment: getAlignment(mes.uid.toString()),
      margin: EdgeInsets.only(top: 20),
      backGroundColor:
          isSender(mes.uid.toString()) ? Color(0xFF08C187) : Color(0xffE7E7ED),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: mes.message != ''
                  ? Text(mes.message,
                      style: TextStyle(
                          color: isSender(mes.uid.toString())
                              ? Colors.white
                              : Colors.black),
                      maxLines: 100,
                      overflow: TextOverflow.ellipsis)
                  : mes.image != ''
                      ? Image.network(
                          mes.image,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 100,
                          // height: 60,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildButton(mes.voice),
                              IconButton(
                                icon: Icon(Icons.replay),
                                onPressed: () async {
                                  print(advancedPlayer.state);
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
// Row(
//   mainAxisAlignment: MainAxisAlignment.end,
//   children: [
//     Text(
//       data['createdOn'] == null
//           ? DateTime.now().toString()
//           : data['createdOn']
//               .toDate()
//               .toString(),
//       style: TextStyle(
//           fontSize: 10,
//           color: isSender(
//                   data['uid'].toString())
//               ? Colors.white
//               : Colors.black),
//     )
//   ],
// )


