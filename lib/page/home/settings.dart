// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unnecessary_string_interpolations

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            // Text(user.photoURL.toString()),
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
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF08C187),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
