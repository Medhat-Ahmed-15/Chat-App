import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _loadingSpinner = false;
  final _auth = FirebaseAuth
      .instance; //this will give us an instance to the fire base auth object which is automatically set up and managed by the fire base auth package.

  void _submiitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
    File pickedImage,
  ) async {
    AuthResult authResult;
    //again, behind the scenes, Firebase will go ahead, send the request and automatically stored thetoken if the request succeeds and managed to token lifetime for us. That's all taken care

    try {
      if (isLogin == true) //login user
      {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else //create new user
      {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
//I want to upload the image before we write all that extra data to our users collection, because a path to the uploaded image should also be something we also write to that users collection in the future.
        var imageUploadPath = FirebaseStorage.instance
            .ref() //ref gives us access to our route cloud storage to our bucket
            .child(
                'user_images') //Child simply allows us to set up a new path a new folder and that allows us to control where we want to store a file or from where we want to read a file.
            .child(authResult.user.uid +
                '.jpg'); //concateenated with .jpg because the captured image its default type is something else weired

        //since .putFile return StorageUploadTask This is not the same as a future, but it has the same idea. Basically, unfortunately, we can't await it because it isn't a future, but we can actually. Use the .onComplete property on it, which will give us a future and we can await this now, the task itself without on complete also has more. We can check if it's currently in progress, if it's cancelled, we can listen to various events which are emitted, which, for example, allows us to track the upload progress. But here I just care about the general completion, which is why I will listen to this on complete future.
        await imageUploadPath.putFile(pickedImage).onComplete;

        var imageUrl = await imageUploadPath.getDownloadURL();

//regarding the username w can't add user name while we are craeting the user using this method (.ceateUserWithEmailAndPassword) because simply it doesn't contain username in its parameters but we can do is after creating a user we then can add extra data to this user

        await Firestore.instance
            .collection(
                'users') //This collection doesn't exist yet, but it will be created on the fly.
            .document(authResult.user
                .uid) //here when I createed a document I used the userId instead of the automatic generated id and this was done by calling .document then passing to it the userId
            .setData(
                {'username': username, 'email': email, 'image_url': imageUrl});

        setState(() {
          _loadingSpinner = true;
        });
      }
      //I want to catch any error of type platform exception. That should essentially be errors that are thrown by Firebase because we, for example, entered an invalid email or an invalid password or anything like that.
    } on PlatformException catch (error) {
      setState(() {
        _loadingSpinner = false;
      });
      var message = 'An error occurred, please check your credentials';

      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(ctx).showSnackBar(
        //since using a context here when rendering snackbar to basically tell Flutter, in which context to render the scaffold. since that auth screen context does not have access to to this scaffold context because this method that this snackbar in it is called from auth form widget so then i will take the context of this widget and also remember that the whole card authentication is in seperate widget so seperat context than the context of the auth screen and this snack bar belongs to the context of the auth form widget
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (error) {
      setState(() {
        _loadingSpinner = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submiitAuthForm, _loadingSpinner),
    );
  }
}
