// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:ui';
import 'package:demo_chat_app/page/login/sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Intro extends StatefulWidget {
  const Intro(this.SetLocale, {Key? key}) : super(key: key);
  final void Function(Locale locale) SetLocale;

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  image: AssetImage('images/bg.jpg'), fit: BoxFit.fill)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Logo(),
                  const Text(
                    'Chat App',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  Column(
                    children: const [
                      Text(
                        'Chat App is a Cross - Platform',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        'mobile messaging with friends',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        'on the world.',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  const TermAndConditions(),
                  LetStart(SetLocale: widget.SetLocale)
                ],
              ),
            ),
          )),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          shape: BoxShape.rectangle,
          color: Colors.white.withOpacity(0.5)),
      child: const Image(
        image: AssetImage('images/whatsapp.png'),
        fit: BoxFit.fitWidth,
      ),
    );
  }
}

class TermAndConditions extends StatelessWidget {
  const TermAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: (() {}),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
          child: Text('Term and Conditions',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5), fontSize: 20)),
        ),
      ),
    );
  }
}

class LetStart extends StatefulWidget {
  const LetStart({required this.SetLocale, Key? key}) : super(key: key);
  final void Function(Locale locale) SetLocale;

  @override
  State<LetStart> createState() => _LetStartState();
}

class _LetStartState extends State<LetStart> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        print(Localizations.localeOf(context).toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginGmail(widget.SetLocale)));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.5)),
          Text(AppLocalizations.of(context)!.letstart,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5), fontSize: 25)),
        ],
      ),
    );
  }
}
