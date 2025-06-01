import 'package:atal_without_krishna/utils/email_verify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../firebase_auth_sevices.dart';
import 'app_setting.dart';
import 'package:firebase_database/firebase_database.dart';
import 'edit_profile.dart';
import 'dart:convert';
import 'dart:io';
import 'help_support.dart';
import 'privacy_security.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color backgroundColor = const Color(0xfffcfdfd);
  final Color textColor = const Color(0xFF212121);
  final Color accentColor = const Color(0xFFc89b3c);

  // Get current user
  String? profilePicBase64;
  User? user = FirebaseAuth.instance.currentUser;
  DatabaseReference? _dbRef;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Format date for display
  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return '${_getMonth(date.month)} ${date.year}';
  }

  String _getMonth(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }

  // Navigate with page transition
  void _navigateWithAnimation(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.00);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  // Fetch user data from Firestore
  Future<DocumentSnapshot?> _getUserData() async {
    if (currentUser == null) return null;
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
  }
  @override
  void initState() {
    super.initState();
    _dbRef = FirebaseDatabase.instance.ref('users/${user!.uid}');
    _getProfilePicture();
  }

  /// Fetch profile picture from the database
  Future<void> _getProfilePicture() async {
    _dbRef!.child('profilePicture').once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        setState(() {
          profilePicBase64 = event.snapshot.value as String?;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? profilePic = profilePicBase64 != null
        ? MemoryImage(base64Decode(profilePicBase64!))
        : AssetImage('assets/default_profile_pic.png') as ImageProvider;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'Profile',
          style: GoogleFonts.instrumentSans(
            color: textColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot?>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
            return Center(
              child: Text(
                'User data not found!',
                style: GoogleFonts.instrumentSans(color: textColor, fontSize: 18),
              ),
            );
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>?;
          String profilePicUrl = userData?['pfp'] ?? '';
          String name = userData?['name'] ?? 'User Name';
          String email = userData?['email'] ?? 'user@example.com';

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'profile_pic',
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: profilePic,
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    email,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 16.0,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _profileOption(LineAwesomeIcons.user_edit_solid, 'Edit Profile', () {
                    _navigateWithAnimation(context, EditProfilePage());
                  }),
                  _profileOption(LineAwesomeIcons.cog_solid, 'App Settings', () {
                    _navigateWithAnimation(context, AppSettingsPage());
                  }),
                  _profileOption(LineAwesomeIcons.question_circle_solid, 'Help & Support', () {
                    _navigateWithAnimation(context, HelpSupportPage());
                  }),
                  _profileOption(LineAwesomeIcons.lock_solid, 'Privacy & Security', () {
                    _navigateWithAnimation(context, PrivacySecurityPage());
                  }),
                  _profileOption(Icons.logout, 'Logot', () {
                    _logout(context);
                  }),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Divider(thickness: 0.4, color: textColor.withOpacity(0.3)),
                      const SizedBox(height: 8),
                      Text(
                        'Version 1.0.0',
                        style: GoogleFonts.instrumentSans(fontSize: 12, color: textColor.withOpacity(0.6)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Member since ${_formatDate(currentUser?.metadata.creationTime)}',
                        style: GoogleFonts.instrumentSans(fontSize: 12, color: textColor.withOpacity(0.6)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Last login: ${_formatDate(currentUser?.metadata.lastSignInTime)}',
                        style: GoogleFonts.instrumentSans(fontSize: 12, color: textColor.withOpacity(0.6)),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Privacy Policy | Terms of Service',
                          style: GoogleFonts.instrumentSans(
                            fontSize: 12,
                            color: accentColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Refresh user data
  Future<void> _refreshData() async {
    setState(() {});
  }

  void _logout(BuildContext context) {
    AuthService().signOut(context: context);
  }

  Widget _profileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: accentColor),
      title: Text(
        title,
        style: GoogleFonts.instrumentSans(
          fontSize: 16,
          color: textColor,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: textColor.withOpacity(0.6)),
      onTap: onTap,
    );
  }
}
