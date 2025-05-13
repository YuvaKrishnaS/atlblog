import 'package:atal_without_krishna/user_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  Future<void> signup({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get UID of the registered user
      String uid = userCredential.user!.uid;

      // Store user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        "name": name,
        "email": email,
        "uid": uid,
        "created_at": FieldValue.serverTimestamp(),
      });

      // Navigate to UserCheck after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UserCheck(),
        ),
      );

      // Show success message
      Fluttertoast.showToast(
        msg: "Registration successful!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Go to UserCheck to decide where to navigate after login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UserCheck(),
        ),
      );
      Fluttertoast.showToast(
        msg: "Login successful!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    }
  }

  Future<void> signOut({
    required BuildContext context,
  }) async {
    bool? shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 0),
                Text(
                  'Are you sure you want to logout?',
                  style: GoogleFonts.instrumentSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                            color: Color(0xff212121),
                          ),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.instrumentSans(
                          color: const Color(0xff212121),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                            color: Color(0xff212121),
                          ),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: GoogleFonts.instrumentSans(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
      await Future.delayed(const Duration(seconds: 1));

      Fluttertoast.showToast(
        msg: "You have been logged out successfully!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 14.0,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UserCheck(),
        ),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    Fluttertoast.showToast(
      msg: 'Google sign in not implemented yet',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.lightBlueAccent,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void _handleAuthError(FirebaseAuthException e) {
    String message = '';
    if (e.code == 'weak-password') {
      message = 'Password is too weak';
    } else if (e.code == 'email-already-in-use') {
      message = 'An account already exists with this email';
    } else if (e.code == 'user-not-found') {
      message = 'No user found for this email';
    } else if (e.code == 'invalid-credential') {
      message = 'Incorrect credentials';
    } else if (e.code == 'network-request-failed') {
      message = 'No Internet Connection';
    } else {
      message = e.code;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
