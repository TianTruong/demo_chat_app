// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
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
  bool isSender(String friend) {
    return friend != widget.friendUid;
  }

  Alignment getAlignment(friend) {
    if (friend != widget.friendUid) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      clipper: ChatBubbleClipper6(
        nipSize: 5,
        radius: 15,
        type: isSender(widget.data['uid'].toString())
            ? BubbleType.sendBubble
            : BubbleType.receiverBubble,
      ),
      alignment: getAlignment(widget.data['uid'].toString()),
      margin: EdgeInsets.only(top: 20),
      backGroundColor: isSender(widget.data['uid'].toString())
          ? Color(0xFF08C187)
          : Color(0xffE7E7ED),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: widget.data['message'] != ''
                  ? Text(widget.data['message'],
                      style: TextStyle(
                          color: isSender(widget.data['uid'].toString())
                              ? Colors.white
                              : Colors.black),
                      maxLines: 100,
                      overflow: TextOverflow.ellipsis)
                  : Image.network(
                      widget.data['image'],
                      fit: BoxFit.cover,
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