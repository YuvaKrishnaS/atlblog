import 'package:atal_without_krishna/home_page.dart';
import 'package:atal_without_krishna/get_started_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserCheck extends StatelessWidget {
  const UserCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // User is logged in -> Navigate to HomePage
            return HomePage();
          } else {
            // User is not logged in -> Navigate to GetStartedPage
            return GetStartedPage();

          }
        }
        // Show a loading indicator until we know the user status
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
