import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/chat/messages.dart';
import 'package:flutter_complete_guide/widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //I could ask on the main dart file for permission sedning notification, but if a user hasn't even locked in, it doesn't make much sense to start sending messages to that user. So instead, here in the chat screen, I want to ask the user whether he's fine with me sending push notifications to him or her .this code wtittn inside initstate will do nothing for android studio but will ask for permission fro ios
  @override
  void initState() {
    final fbm = FirebaseMessaging();
    //fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      //on message, which is another argument you can pass in is always triggered whenever you receive a message and the app is running in the foreground. So whenever the app is currently open

      print(msg);
      return;
    }, onLaunch: (msg) {
      //I will also specify on launch, which should be triggered if the app was terminated and we got a message,
      print(msg);
      return;
    }, onResume: (msg) {
      print(msg);
      return;
    });
    fbm.subscribeToTopic('chat');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mito chat area'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout', //itemIdentifier
              ),
            ],
            onChanged: (itemIdentifier) {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Messages(),
          ),
          NewMessage()
        ],
      ),
    );
  }
}
