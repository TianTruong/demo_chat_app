// ignore_for_file: must_be_immutable

import 'package:demo_chat_app/page/home/chats.dart';
import 'package:demo_chat_app/page/home/people.dart';
import 'package:demo_chat_app/page/home/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  var screens = const [Chats(), People(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoTabScaffold(
        resizeToAvoidBottomInset: true,
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(
              // label: "Chats",
              icon: Icon(CupertinoIcons.chat_bubble_2_fill,
                  color: Color(0xFF08C187)),
            ),
            BottomNavigationBarItem(
              // label: "People",
              icon: Icon(CupertinoIcons.person_alt_circle,
                  color: Color(0xFF08C187)),
            ),
            BottomNavigationBarItem(
              // label: "Settings",
              icon:
                  Icon(CupertinoIcons.settings_solid, color: Color(0xFF08C187)),
            )
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return screens[index];
        },
      ),
    );
  }
}
