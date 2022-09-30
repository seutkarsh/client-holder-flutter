import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth auth = FirebaseAuth.instance;

//error dialog box

//signup user

Future<User> signUp(String email, String password, BuildContext context) async {
  try {
    final credentials = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return Future.value(credentials.user);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
  return Future.value(null);
}

//signin user

Future<User> signin(String email, String password, BuildContext context) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return Future.value(credential.user);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
  // since we are not actually continuing after displaying errors
  // the false value will not be returned
  // hence we don't have to check the valur returned in from the signin function
  // whenever we call it anywhere
  return Future.value(null);
}

//signout user
Future<bool> signOutUser() async {
  await auth.signOut();
  return Future.value(true);
}
