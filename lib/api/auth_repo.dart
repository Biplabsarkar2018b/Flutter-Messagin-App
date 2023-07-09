import 'package:chatty/common/utils/utils.dart';
import 'package:chatty/features/auth/login.dart';
import 'package:chatty/features/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepoProvider = StateNotifierProvider<AuthRepo, bool>((ref) {
  return AuthRepo(
    firebaseAuth: FirebaseAuth.instance,
    googleSignIn: GoogleSignIn(),
    firestore: FirebaseFirestore.instance,
  );
});

class AuthRepo extends StateNotifier<bool> {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  AuthRepo({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
  })  : _auth = firebaseAuth,
        _firestore = firestore,
        _googleSignIn = googleSignIn,
        super(false);

  void googleSignIn(BuildContext context) async {
    state = true;
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User user = userCredential.user!;
      final docSnap =
          await _firestore.collection('users').doc(user.email).get();
      if (!docSnap.exists) {
        await _firestore.collection('users').doc(user.email).set({
          'displayName': user.displayName,
          'profilePhoto': user.photoURL,
          'isActive': true,
          'chats':[],
        });
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (e, st) {
      showSnackbar(context, e.toString());
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    state = false;
  }

  void signOut(BuildContext context) async {
    state = true;
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      showSnackbar(context, 'Signed Out');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ));
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.toString());
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    state = false;
  }
}
