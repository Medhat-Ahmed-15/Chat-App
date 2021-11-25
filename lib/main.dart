import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/chat_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mito',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness
            .dark, //to let flutter know that this purple color is a very dark color and that any contrasting color on this purple background should therefore be a bright color. We don't need to do this on the primary swatch there. Flutter should drive does automatically, but we should do this here. To avoid that, we end up with black text on purple, for example.

        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      home: StreamBuilder(
        // we can use firebasAuth.instance.onAuthStateChanged, and this gives us a stream and this stream will emit a new value whenever the auth state changes and the auth state changes, when we sign up, when we log in, when we log out, but also when the app is loading, it will check if there is a cached token and that caching and storage will be managed entirely by Firebase here by the Firebase Flutter package. And if it finds such a token, it will validate the token and if token is valid, it will even use that token even after a new app startup. So did the entire Tolkan stretch and manage it across app restarts stuff is fully managed by Firebase
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, streamSnapShot) {
          if (streamSnapShot.hasData) {
            return ChatScreen();
          }
          return AuthScreen();
        },
      ),
    );
  }
}
