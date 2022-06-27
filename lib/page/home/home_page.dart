// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_print

import 'package:demo_chat_app/bloc/check/check_bloc.dart';
import 'package:demo_chat_app/page/home/chat_detail/chat_detail.dart';
import 'package:demo_chat_app/page/home/chats.dart';
import 'package:demo_chat_app/page/home/people.dart';
import 'package:demo_chat_app/page/home/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage(this.abc, {Key? key}) : super(key: key);
  final void Function(Locale locale) abc;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return HomeViewSmall(widget.abc);
          } else {
            return HomeViewLarge(widget.abc);
          }
        },
      ),
    );
  }
}

class HomeViewSmall extends StatefulWidget {
  const HomeViewSmall(this.abc, {Key? key}) : super(key: key);
  final void Function(Locale locale) abc;

  @override
  State<HomeViewSmall> createState() => _HomeViewSmallState();
}

class _HomeViewSmallState extends State<HomeViewSmall> {
  String? friendUid;
  String? friendName;

  void SetChat(String _friendUid, String _friendName) {
    setState(() {
      friendUid = _friendUid;
      friendName = _friendName;
      print(friendUid);
      print(friendName);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screens = [
      Chats(SetChat),
      People(SetChat),
      SettingsScreen(SetLocale: widget.abc)
    ];
    return Scaffold(
      bottomNavigationBar: CupertinoTabScaffold(
        resizeToAvoidBottomInset: true,
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble_2_fill,
                  color: Color(0xFF08C187)),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_alt_circle,
                  color: Color(0xFF08C187)),
            ),
            BottomNavigationBarItem(
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

class HomeViewLarge extends StatefulWidget {
  const HomeViewLarge(this.abc, {Key? key}) : super(key: key);
  final void Function(Locale locale) abc;
  @override
  State<HomeViewLarge> createState() => _HomeViewLargeState();
}

class _HomeViewLargeState extends State<HomeViewLarge> {
  String? friendUid;
  String? friendName;

  void SetChat(String _friendUid, String _friendName) {
    setState(() {
      friendUid = _friendUid;
      friendName = _friendName;
      print(friendUid);
      print(friendName);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screens = [
      Chats(SetChat),
      People(SetChat),
      SettingsScreen(SetLocale: widget.abc)
    ];

    return BlocProvider(
      create: (context) => CheckBloc(),
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 2,
              child: LayoutBuilder(
                  builder: (context, constraints) => Scaffold(
                        bottomNavigationBar: CupertinoTabScaffold(
                          resizeToAvoidBottomInset: true,
                          tabBar: CupertinoTabBar(
                            items: const [
                              BottomNavigationBarItem(
                                icon: Icon(CupertinoIcons.chat_bubble_2_fill,
                                    color: Color(0xFF08C187)),
                              ),
                              BottomNavigationBarItem(
                                icon: Icon(CupertinoIcons.person_alt_circle,
                                    color: Color(0xFF08C187)),
                              ),
                              BottomNavigationBarItem(
                                icon: Icon(CupertinoIcons.settings_solid,
                                    color: Color(0xFF08C187)),
                              )
                            ],
                          ),
                          tabBuilder: (BuildContext context, int index) {
                            return screens[index];
                          },
                        ),
                      )),
            ),
            Expanded(
              flex: 3,
              child: LayoutBuilder(
                  builder: (context, constraints) =>
                      (friendUid == null || friendName == null)
                          ? Container(
                              color: Colors.white,
                              child: Center(
                                child: Image.asset('images/whatsapp.png',
                                    color: Colors.grey.withOpacity(0.2)),
                              ),
                            )
                          : BlocBuilder<CheckBloc, CheckState>(
                              builder: (context, state) {
                                return ChatDetail(
                                  friendUid: friendUid,
                                  friendName: friendName,
                                );
                              },
                            )),
            ),
          ],
        ),
      ),
    );
  }
}
