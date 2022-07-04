// ignore_for_file: avoid_print, use_key_in_widget_constructors, prefer_const_constructors

import 'package:demo_chat_app/app.dart';
import 'package:demo_chat_app/bloc/check/check_bloc.dart';
import 'package:demo_chat_app/bloc/locale/locale_bloc.dart';
import 'package:demo_chat_app/bloc/login/login_bloc.dart';
import 'package:demo_chat_app/bloc/send/send_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  runApp(
      //   BlocProvider(
      //   create: (context) => LocaleBloc(),
      //   child: App(),
      // )
      MultiBlocProvider(providers: [
    BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(),
    ),
    BlocProvider<CheckBloc>(
      create: (context) => CheckBloc(),
    ),
    BlocProvider<SendBloc>(
      create: (context) => SendBloc(),
    ),
    BlocProvider<LocaleBloc>(
      create: (context) => LocaleBloc(),
    ),
  ], child: App()));
}
