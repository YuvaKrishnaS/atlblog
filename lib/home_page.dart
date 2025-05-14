import 'dart:convert';
import 'dart:ui';
import 'package:atal_without_krishna/firebase_auth_sevices.dart';
import 'package:atal_without_krishna/get_started_page.dart';
import 'package:atal_without_krishna/interactive_pages/learn_basics.dart';
import 'package:atal_without_krishna/pages/profile_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../pages/tutorials_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../user_data_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../cards/latestPost_card.dart'; // Import the LatestPostCard widget
import 'login_page.dart';
import '../splash.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _refreshContent() async {
    // Add logic to reload data here if needed
    setState(() {}); // triggers a rebuild and refreshes StreamBuilders, etc.
    await Future.delayed(const Duration(milliseconds: 500));
  }
  final Color primaryColor = Color(0xFF192841); // Deep Navy Blue
  final Color secondaryColor = Color(0xFFa38d42); // Muted Gold
  final Color neutralColor = Color(0xfff0f4f5); // Off-White
  final Color accentColor = Color(0xFFc89b3c); // Brighter Gold
  final Color textColor = Color(0xFF212121); // Very Dark Gray
  final Color IconColor = Color(0xFF535353);
  final Color backgroundColor = Color(0xfffcfdfd); // Simple White
  final double element_padding = 16.0;
  final double spaceForSearch = 20.0;
  final double spaceFor_CardSections = 10.0;
  final double spaceForLearn = 0.0;
  final double spaceForLatestPost = 20.0;
  final TextStyle FontChoice = GoogleFonts.instrumentSans();

  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  User? user = FirebaseAuth.instance.currentUser;
  String? profilePicBase64;
  // User? user = FirebaseAuth.instance.currentUser;
  DatabaseReference? _dbRef;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  void _logout(BuildContext context) async {
    await AuthService().signOut(context: context);
  }

  void _splash(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _dbRef = FirebaseDatabase.instance.ref('users/${user!.uid}');
    _getProfilePicture();

    // Listen to search bar changes
    _searchController.addListener(() {
      setState(() {
        _isSearching = _searchController.text.isNotEmpty;
      });
    });
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
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? profilePic = profilePicBase64 != null
        ? MemoryImage(base64Decode(profilePicBase64!))
        : AssetImage('assets/default_profile_pic.png') as ImageProvider;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Text(
                'ATL Blog',
                style: GoogleFonts.instrumentSans(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout_rounded, color: IconColor),
              title: Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return _appbar();
        },
        body: RefreshIndicator(
          onRefresh: _refreshContent,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(00.0), // Zero padding to cover the whole screen
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: element_padding),
                _searchSection(), // Search Bar Section
                SizedBox(height: spaceForSearch),
                _learnBasicsButton(), // Learn the Basics Button
                SizedBox(height: 15),
                _latestPostsSection(), // Tutorials Section
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _appbar() {
    ImageProvider? profilePic = profilePicBase64 != null
        ? MemoryImage(base64Decode(profilePicBase64!))
        : AssetImage('assets/default_profile_pic.png') as ImageProvider;

    return [
      SliverAppBar(
        pinned: true,
        floating: true,
        backgroundColor: Colors.transparent,
        expandedHeight: 80.0,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              alignment: Alignment.center,
              color: Colors.white.withOpacity(0.2), // Adjust for glass effect
              child: FlexibleSpaceBar(
                title: Text(
                  'ATL Blog',
                  style: GoogleFonts.instrumentSans(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                centerTitle: true,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 300),
                    pageBuilder: (_, __, ___) => ProfilePage(),
                    transitionsBuilder: (_, animation, __, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(position: offsetAnimation, child: child);
                    },
                  ),
                );
              },
              child: Consumer<UserDataProvider>(
                builder: (context, userProvider, child) {
                  return CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 18,
                    backgroundImage: profilePic,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ];
  }

  Widget _searchSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: element_padding),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: textColor.withOpacity(0.2),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Row(
          children: [
            // PNG Logo/Icon on the left
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: Image.asset(
                'assets/search.png', // Add your PNG asset here
                width: 24,
                height: 24,
              ),
            ),
            // TextField with hiding cursor when not focused
            Expanded(
              child: Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    _isSearching = _searchController.text.isNotEmpty;
                  });
                },
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  style: FontChoice.copyWith(
                    fontSize: 16,
                    color: textColor,
                  ),
                  cursorColor: textColor, // Set cursor color
                  showCursor: _searchFocusNode.hasFocus, // Hide cursor if not focused
                  decoration: InputDecoration(
                    hintText: 'What are you looking for today?',
                    hintStyle: FontChoice.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: textColor.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    setState(() {
                      _isSearching = text.isNotEmpty;
                    });
                  },
                ),
              ),
            ),
            // Show clear button only when something is typed
            if (_isSearching)
              GestureDetector(
                onTap: () {
                  _searchController.clear(); // Clear search text
                  _searchFocusNode.unfocus(); // Remove focus
                  setState(() {
                    _isSearching = false;
                  });
                },
                child: Icon(
                  Icons.clear_rounded,
                  color: IconColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _learnBasicsButton() {
    return Hero(
      tag: 'card_learn',

      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: element_padding),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 1000),
                  pageBuilder: (_, __, ___) => LearnBasicsScreen(),
                  transitionsBuilder: (_, animation, __, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(position: offsetAnimation, child: child);
                  },
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 115,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF01b4db), Color(0xFF0083b0)],
                  begin: Alignment.centerLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Opacity(
                      opacity: 0.75,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(33),
                          bottomRight: Radius.circular(30),
                        ),
                        child: Image.asset(
                          'assets/arduino.png',
                          width: 230,
                          height: 205,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Learn the \nBasics',
                          style: GoogleFonts.instrumentSans(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                            shadows: const [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _latestPostsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: element_padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hero(
                tag: 'tutorialsHero',
                child: Text(
                  'Tutorials',
                  style: GoogleFonts.kanit(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TutorialsPage()),
                  );
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spaceFor_CardSections),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: element_padding),
          child: LatestPostsList(),
        ),
      ],
    );
  }
}
