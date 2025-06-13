import 'dart:convert';
import 'dart:ui';
import 'package:atal_without_krishna/components/app_drawer.dart';
import 'package:atal_without_krishna/firebase_auth_sevices.dart';
import 'package:atal_without_krishna/get_started_page.dart';
import 'package:atal_without_krishna/interactive_pages/learn_basics.dart';
import 'package:atal_without_krishna/pages/profile_page.dart';
import 'package:atal_without_krishna/utils/theme_color.dart';
import 'package:atal_without_krishna/utils/theme_provider.dart';
import 'package:atal_without_krishna/utils/theme_color.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../pages/tutorials_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../user_data_manager.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../cards/latestPost_card.dart';
import 'login_page.dart';
import '../splash.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  Future<void> _refreshContent() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
  }

  final double element_padding = 16.0;
  final double spaceForSearch = 20.0;
  final double spaceFor_CardSections = 10.0;
  final double spaceForLearn = 0.0;
  final double spaceForLatestPost = 20.0;

  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  User? user = FirebaseAuth.instance.currentUser;
  String? profilePicBase64;
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

    // Initialize animations
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();

    // Listen to search bar changes
    _searchController.addListener(() {
      setState(() {
        _isSearching = _searchController.text.isNotEmpty;
      });
    });
  }

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
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        ImageProvider? profilePic = profilePicBase64 != null
            ? MemoryImage(base64Decode(profilePicBase64!))
            : AssetImage('assets/default_profile_pic.png') as ImageProvider;

        return Scaffold(
          drawer: AppDrawer(
            primaryColor: ThemeColors.getCardColor(context),
            iconColor: ThemeColors.getTextColor(context),
          ),
          backgroundColor: ThemeColors.getBackgroundColor(context),
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return _appbar(themeProvider);
            },
            body: RefreshIndicator(
              onRefresh: _refreshContent,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(0.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: element_padding),
                        _themeToggleSection(),
                        SizedBox(height: 20),
                        _searchSection(),
                        SizedBox(height: spaceForSearch),
                        _learnBasicsButton(),
                        SizedBox(height: 15),
                        _latestPostsSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _appbar(ThemeProvider themeProvider) {
    ImageProvider? profilePic = profilePicBase64 != null
        ? MemoryImage(base64Decode(profilePicBase64!))
        : AssetImage('assets/default_profile_pic.png') as ImageProvider;

    return [
      SliverAppBar(
        pinned: true,
        floating: true,
        backgroundColor: Color(0xfff5f6f7),
        expandedHeight: 80.0,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              alignment: Alignment.center,
              color: ThemeColors.getBackgroundColor(context).withOpacity(0.8),
              child: FlexibleSpaceBar(
                title: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Text(
                    'ATL Blog',
                    style: GoogleFonts.instrumentSans(
                      color: ThemeColors.getTextColor(context),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
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
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    child: CircleAvatar(
                      backgroundColor: ThemeColors.getCardColor(context),
                      radius: 18,
                      backgroundImage: profilePic,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ];
  }

  Widget _themeToggleSection() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: element_padding),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeColors.getCardColor(context),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).isDarkMode
                      ? Colors.black26
                      : Colors.grey.withOpacity(0.2),
                  blurRadius: 10.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        key: ValueKey(themeProvider.isDarkMode),
                        color: ThemeColors.getAccentColor(context),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Theme Mode',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.getTextColor(context),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Light',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 14,
                        color: ThemeColors.getSecondaryTextColor(context),
                      ),
                    ),
                    SizedBox(width: 8),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 50,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: themeProvider.isDarkMode
                            ? ThemeColors.getAccentColor(context)
                            : Colors.grey[300],
                      ),
                      child: AnimatedAlign(
                        duration: Duration(milliseconds: 300),
                        alignment: themeProvider.isDarkMode
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            themeProvider.setThemeMode(
                                themeProvider.isDarkMode
                                    ? ThemeMode.light
                                    : ThemeMode.dark
                            );
                          },
                          child: Container(
                            width: 21,
                            height: 21,
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Dark',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 14,
                        color: ThemeColors.getSecondaryTextColor(context),
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
  }

  Widget _searchSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: element_padding),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: ThemeColors.getCardColor(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).isDarkMode
                  ? Colors.black26
                  : Colors.grey.withOpacity(0.2),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: AnimatedRotation(
                turns: _isSearching ? 0.5 : 0,
                duration: Duration(milliseconds: 300),
                child: Icon(
                  Icons.search,
                  color: ThemeColors.getAccentColor(context),
                  size: 24,
                ),
              ),
            ),
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
                  style: GoogleFonts.instrumentSans(
                    fontSize: 16,
                    color: ThemeColors.getTextColor(context),
                  ),
                  cursorColor: ThemeColors.getAccentColor(context),
                  showCursor: _searchFocusNode.hasFocus,
                  decoration: InputDecoration(
                    hintText: 'What are you looking for today?',
                    hintStyle: GoogleFonts.instrumentSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ThemeColors.getSecondaryTextColor(context),
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
            if (_isSearching)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  _searchFocusNode.unfocus();
                  setState(() {
                    _isSearching = false;
                  });
                },
                child: AnimatedScale(
                  scale: _isSearching ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Icon(
                    Icons.clear_rounded,
                    color: ThemeColors.getSecondaryTextColor(context),
                  ),
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
      child: ScaleTransition(
        scale: _scaleAnimation,
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
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: double.infinity,
              height: 115,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: Theme.of(context).isDarkMode
                      ? [Color(0xFF1E3A8A), Color(0xFF1E40AF)]
                      : [Color(0xFF01b4db), Color(0xFF0083b0)],
                  begin: Alignment.centerLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).isDarkMode
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.cyan.withOpacity(0.3),
                    blurRadius: 15.0,
                    offset: Offset(0, 8),
                  ),
                ],
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 800),
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(-30 + (30 * value), 0),
                              child: Opacity(
                                opacity: value,
                                child: Text(
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
                              ),
                            );
                          },
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
                child: AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 300),
                  style: GoogleFonts.kanit(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.getTextColor(context),
                  ),
                  child: Text('Tutorials'),
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
                    color: ThemeColors.getAccentColor(context),
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