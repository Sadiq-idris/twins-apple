import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices{


  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentuser(){
    User? user = _auth.currentUser;

    return user;
  }

  Future<dynamic> signUp(String name, String email, password) async{
    try{
      // creating user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // getting user class
      User? user = userCredential.user;

      if(user != null){
        user.updateDisplayName(name);
        user.sendEmailVerification();
        user.reload();
      }

      return user;
    } on FirebaseAuthException catch(e) {
      if(e.code == "weak-password"){

        return "The passsword provided is too weak.";
      } else if(e.code == "email-already-in-use"){
        return "The account already exists for that email";
      } else {
        return e.message ?? "An error occurred";
      }
    }
  }

  Future<dynamic> signIn(String email, password) async {
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      return userCredential.user;
    } on FirebaseAuthException catch(e){
      if(e.code == "user-not-found"){
        return "The account does not exist";
      } else if(e.code == "wrong-password"){
        return "Wrong password provided for that user.";
      } else{
        return "Username or password is incorrect try again.";
      }
    }
  }


  Future<void> signOut() async{
    try{
      await _auth.signOut();
    } catch (e){
      debugPrint(e.toString());
    }
  }

  Future<void> resetPassword(String email) async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
    } catch(e){
      debugPrint(e.toString());
    }
  }

  Future<dynamic> signInWithGoogle() async{
    
    final GoogleSignIn googleSignIn = GoogleSignIn();
      
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if(googleSignInAccount != null){
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try{
        final UserCredential userCredential = await _auth.signInWithCredential(credential);

        User? user = userCredential.user;

        return user;
      } on FirebaseAuthException catch(e){
        if(e.code == "account-exists-with-different-credential"){
          
          return 'The account already exists with a different credential.';
        } else if(e.code == "invalid-credential"){
          return 'Error occurred while accessing credentials. Try again.';
        }
      } catch(e){
        return 'Error occurred using Google Sign-In. Try again.';
      }
    }

  }
}