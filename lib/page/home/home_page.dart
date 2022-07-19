// ignore_for_file: must_be_immutable, non_constant_identifier_names, avoid_print, prefer_const_constructors, prefer_final_fields

import 'package:demo_chat_app/bloc/check/check_bloc.dart';
import 'package:demo_chat_app/page/home/chat_detail/chat_detail.dart';
import 'package:demo_chat_app/page/home/chats.dart';
import 'package:demo_chat_app/page/home/people.dart';
import 'package:demo_chat_app/page/home/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return const HomeViewSmall();
        } else {
          return const HomeViewLarge();
        }
      },
    );
  }
}

class HomeViewSmall extends StatefulWidget {
  const HomeViewSmall({Key? key}) : super(key: key);

  @override
  State<HomeViewSmall> createState() => _HomeViewSmallState();
}

class _HomeViewSmallState extends State<HomeViewSmall> {
  var screens = [const Chats(), const People(), const SettingsScreen()];
  int _selectedIndex = 0;
  GlobalKey<ScaffoldState> _profileScaffoldKey = GlobalKey<ScaffoldState>();
  void callChatDetailScreen(
      BuildContext context, String chatId, String name, String uid) {
    Get.to(ChatDetail(
      chatDocId: chatId,
      friendName: name,
      friendUid: uid,
    ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckBloc, CheckState>(
      listener: (context, state) {
        if (state is SetChatDocIdState) {
          if (MediaQuery.of(context).size.width < 600) {
            callChatDetailScreen(
                context, state.ChatDocID, state.friendName, state.friendUid);
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _profileScaffoldKey,
        body: Center(
          child: screens.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: const Color(0xFF08C187),
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble_2, size: 30),
              label: AppLocalizations.of(context)!.chat,
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_alt_circle, size: 30),
              label: AppLocalizations.of(context)!.people,
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings_solid, size: 30),
              label: AppLocalizations.of(context)!.setting,
            )
          ],
        ),
      ),
    );
  }
}

class HomeViewLarge extends StatefulWidget {
  const HomeViewLarge({Key? key}) : super(key: key);
  @override
  State<HomeViewLarge> createState() => _HomeViewLargeState();
}

class _HomeViewLargeState extends State<HomeViewLarge> {
  int _selectedIndex = 0;
  GlobalKey<ScaffoldState> _profileScaffoldKey = GlobalKey<ScaffoldState>();
  var screens = [const Chats(), const People(), const SettingsScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: _profileScaffoldKey,
            body: Center(
              child: screens.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: const Color(0xFF08C187),
              unselectedItemColor: Colors.grey,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.chat_bubble_2, size: 30),
                  label: AppLocalizations.of(context)!.chat,
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person_alt_circle, size: 30),
                  label: AppLocalizations.of(context)!.people,
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.settings_solid, size: 30),
                  label: AppLocalizations.of(context)!.setting,
                )
              ],
            ),
          ),
        ),
        const Expanded(
          flex: 3,
          child: RightLargeWidget(),
        ),
      ],
    );
  }
}

class RightLargeWidget extends StatelessWidget {
  const RightLargeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckBloc, CheckState>(
      builder: (context, state) {
        debugPrint("---BlocBuilder<CheckBloc>----");
        if (state is SetChatDocIdState) {
          return ChatDetail(
            chatDocId: state.ChatDocID,
            friendUid: state.friendUid,
            friendName: state.friendName,
          );
        }
        return Container(
          color: Colors.white,
          child: Center(
            child: Image.asset('images/whatsapp.png',
                color: Colors.grey.withOpacity(0.2)),
          ),
        );
      },
    );
  }
}
