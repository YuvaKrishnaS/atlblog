import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_auth_sevices.dart';

class AppDrawer extends StatefulWidget {
  final Color primaryColor;
  final Color iconColor;

  const AppDrawer({
    Key? key,
    required this.primaryColor,
    required this.iconColor,
  }) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _fetchUserData();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.3, 1.0, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (doc.exists) {
          setState(() {
            userData = doc.data() as Map<String, dynamic>?;
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Error fetching user data: $e');
      }
    }
  }

  void _logout(BuildContext context) async {
    await AuthService().signOut(context: context);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value * 300, 0),
          child: Drawer(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2C3E50),
                    Color(0xFF34495E),
                    Color(0xFF2C3E50),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Header Section
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: _buildUserHeader(),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Menu Items
                    Expanded(
                      child: _buildMenuItems(),
                    ),

                    // Logout Button
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildLogoutButton(),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Profile Picture
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: isLoading
                  ? Container(
                color: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.grey[600],
                ),
              )
                  : Container(
                color: Colors.blue[100],
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.blue[800],
                ),
              ),
            ),
          ),

          SizedBox(height: 15),

          // User Name
          Text(
            isLoading
                ? 'Loading...'
                : userData?['name'] ?? 'User Name',
            style: GoogleFonts.instrumentSans(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 5),

          // User Email
          Text(
            isLoading
                ? ''
                : userData?['email'] ?? user?.email ?? '',
            style: GoogleFonts.instrumentSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    final menuItems = [
      {
        'icon': Icons.home_rounded,
        'title': 'Home Screen',
        'color': Color(0xFFFF9500),
      },
      {
        'icon': Icons.person_rounded,
        'title': 'Profile',
        'color': Color(0xFF34C759),
      },
      {
        'icon': Icons.favorite_rounded,
        'title': 'My Wishlist',
        'color': Color(0xFFFF2D92),
      },
      {
        'icon': Icons.shopping_bag_rounded,
        'title': 'My Orders',
        'color': Color(0xFF007AFF),
      },
      {
        'icon': Icons.notifications_rounded,
        'title': 'Notifications',
        'color': Color(0xFFFF9500),
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset((1 - value) * 200, 0),
              child: Opacity(
                opacity: value,
                child: _buildMenuItem(
                  menuItems[index]['icon'] as IconData,
                  menuItems[index]['title'] as String,
                  menuItems[index]['color'] as Color,
                  index,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color iconColor, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            // Handle menu item tap
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: index == 0 ? iconColor.withOpacity(0.2) : Colors.transparent,
            ),
            child: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  title,
                  style: GoogleFonts.instrumentSans(
                    fontSize: 16,
                    fontWeight: index == 0 ? FontWeight.w600 : FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => _logout(context),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  'Logout',
                  style: GoogleFonts.instrumentSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}