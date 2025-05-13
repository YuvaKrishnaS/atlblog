// In UserDataProvider (user_data_manager.dart)
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataProvider extends ChangeNotifier {
  User? _user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? _userData;
  String? _profilePicBase64;

  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;

  // Handle profile picture logic
  ImageProvider? get profilePic {
    if (_profilePicBase64 != null && _profilePicBase64!.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(_profilePicBase64!));
      } catch (e) {
        print('Error decoding base64 image: $e');
      }
    }
    return AssetImage('assets/default_profile_pic.png');
  }

  Future<void> fetchUserData() async {
    if (_user != null) {
      // Get Firestore data (name, email, etc.)
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();

      if (snapshot.exists) {
        _userData = snapshot.data() as Map<String, dynamic>?;
      }

      // Get PFP from Realtime Database
      DatabaseReference dbRef = FirebaseDatabase.instance.ref('users/${_user!.uid}');
      DataSnapshot profileSnapshot = await dbRef.child('profilePicture').get();

      if (profileSnapshot.value != null) {
        _profilePicBase64 = profileSnapshot.value as String?;
      }

      notifyListeners(); // Notify to refresh UI
    }
  }
}
