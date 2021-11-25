import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final bool _loadingSpinner;

  Function _submiitAuthForm;
  AuthForm(this._submiitAuthForm, this._loadingSpinner);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File _pickedImageFile;
  var isLogin = true;

  void _pickedImageFunction(File image) {
    _pickedImageFile = image;
  }

  void _trysubmit(BuildContext ctx) {
    //this will trigger all the validators of all the text form fields in the form.
    final isValid = _formKey.currentState.validate();

    //his will essentially just close the soft keyboard, which might still be open as soon as we submit the form so that the keyboard always closes because this will move the focus away from any input field
    FocusScope.of(context).unfocus();

    if (_pickedImageFile == null && !isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image'),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      //what this will do is it will go to all the text form fields and on every text form field, it will trigger on saved.
      _formKey.currentState.save();

      widget._submiitAuthForm(
          _userEmail
              .trim(), //So this will remove any extra white space on email, password and username
          _userPassword
              .trim(), //So this will remove any extra white space on email, password and username
          _userName
              .trim(), //So this will remove any extra white space on email, password and username
          isLogin,
          ctx,
          _pickedImageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 20,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey, //el key dah 3ashan 2a2dr a access el form dee
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, //This makes sure that the column does not take as much as possible, but only as much as needed.
                children: [
                  if (!isLogin) UserImagePicker(_pickedImageFunction),
                  TextFormField(
                    key: ValueKey(
                        'email'), //keys are added to each textField to avoid the bug that occurs when removing a widget the data of this widget is shifted to the other widget so just by adding a key value to each textField avoids this bug
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }

                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: ValueKey(
                          'username'), //keys are added to each textField to avoid the bug that occurs when removing a widget the data of this widget is shifted to the other widget so just by adding a key value to each textField avoids this bug
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey(
                        'password'), //keys are added to each textField to avoid the bug that occurs when removing a widget the data of this widget is shifted to the other widget so just by adding a key value to each textField avoids this bug
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }

                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  widget._loadingSpinner == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RaisedButton(
                          onPressed: () {
                            _trysubmit(context);
                          },
                          child: Text(
                            isLogin == true ? 'Login' : 'Signup',
                          ),
                        ),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin == true
                            ? 'Create an account'
                            : 'I already have an account',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
