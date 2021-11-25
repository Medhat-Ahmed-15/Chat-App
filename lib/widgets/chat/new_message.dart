import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  var _controller = new TextEditingController();

  void _sendMessage() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final currentUserData = await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .get();
    Firestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': currentUser.uid,
      'userName': currentUserData['username'],
      'userImage': currentUserData['image_url']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                //since text field tries to take as much space same as row so i will wrap it with expanded
                decoration: InputDecoration(label: Text('Send a message...')),
                onChanged: (value) {
                  //this will run on every keystroke. So we update the stored entered message with every keystroke
                  setState(() {
                    _enteredMessage = value;
                  });
                },
              ),
            ),
            IconButton(
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              icon: Icon(Icons.send),
            )
          ],
        ),
      ),
    );
  }
}
