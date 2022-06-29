// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unnecessary_string_interpolations, deprecated_member_use

import 'package:demo_chat_app/bloc/locale/locale_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String language = 'en';
  var items = [
    'en',
    'vi',
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return BlocListener<LocaleBloc, LocaleState>(
      listener: (context, state) {},
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              user.photoURL != null
                  ? Center(
                      child: ClipOval(
                        child: Image.network(
                          user.photoURL!,
                          fit: BoxFit.cover,
                          cacheHeight: 160,
                          cacheWidth: 160,
                        ),
                      ),
                    )
                  : Center(
                      child: ClipOval(
                        child: Image.asset(
                          'images/bg.jpg',
                          fit: BoxFit.cover,
                          cacheHeight: 160,
                          cacheWidth: 160,
                        ),
                      ),
                    ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('${user.displayName!}',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ),
              ),
              Card(child: ListTile(title: Text('ID: ${user.uid}'))),
              Card(child: ListTile(title: Text('Gmail: ${user.email!}'))),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: DropdownButton(
                    value: language,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        language = newValue!;
                        // widget.SetLocale(
                        //     Locale.fromSubtags(languageCode: language));
                        context.read<LocaleBloc>().add(SetLocaleEvent(
                            Locale.fromSubtags(languageCode: language)));

                        print(Localizations.localeOf(context).toString());
                      });
                    },
                  ),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF08C187),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      AppLocalizations.of(context)!.signout,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: Text(
                                  '${AppLocalizations.of(context)!.signout}?'),
                              actions: [
                                FlatButton(
                                    child:
                                        Text(AppLocalizations.of(context)!.yes),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      FirebaseAuth.instance.signOut();
                                    }),
                                FlatButton(
                                    child:
                                        Text(AppLocalizations.of(context)!.no),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              ],
                            ));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
