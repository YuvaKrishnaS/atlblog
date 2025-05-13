import 'dart:async';
import 'dart:ui';
import 'package:atal_without_krishna/get_started_page.dart';
import 'package:atal_without_krishna/home_page.dart';
import 'package:atal_without_krishna/user_check.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  // Circle positions
  double _topSmallCircle = -250; // Starts off-screen
  double _topBigCircle = -400;
  double _bottomBigCircle = -500;
  double _bottomCircle = -400;
  double _bottomRightCircle = 800;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Opacity animation for text and logo
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start animation after a delay
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _topSmallCircle = 5;
        _topBigCircle = -230;
        _bottomBigCircle = 20;
        _bottomCircle = -180;
        _bottomRightCircle = (MediaQuery.of(context).size.height / 2);
      });

      _controller.forward(); // Start opacity animation
    });

    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async{
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('hasSeenSplash', true);
    await Future.delayed(Duration(seconds: 5));

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserCheck()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade200.withOpacity(0),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              color: Colors.white,
            ),
          ),

          // 🔵 Top Small Circle (Animated)
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            curve: Curves.easeOut,
            top: _topSmallCircle,
            left: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFFF0303), Color(0xFF5C79EC)],
                  begin: Alignment.bottomRight,
                  end: Alignment.centerLeft,
                ),
              ),
            ),
          ),

          // 🟢 Top Big Circle (Animated)
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            curve: Curves.easeOut,
            top: _topBigCircle,
            left: -50,
            right: -50,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF59e34f), Color(0xFFFFEA03)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // 🟠 Bottom Big Circle (Animated)
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            curve: Curves.easeOut,
            bottom: _bottomBigCircle,
            left: -50,
            right: -50,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xff2DFF03), Color(0xFF5296B9)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),

          // 🟣 Bottom Big Circle (Animated)
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            curve: Curves.easeOut,
            bottom: _bottomCircle,
            left: -50,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF5C79EC), Color(0xFFFF0303)],
                  begin: Alignment.centerLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // 🔥 New Bottom-Right Circle (Animated)
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            curve: Curves.easeOut,
            bottom: _bottomRightCircle,
            right: -60,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF2AE161), Color(0xFF5296B9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Blurred Background Overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 25),
              child: Container(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          // 🏆 Centered Logo & Text (Animated Fade In)
          // 🏆 Centered Logo & Text (Fixed Animation)
          Center(
            child: AnimatedBuilder(
              animation: _controller, // Rebuild when animation updates
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: _opacityAnimation.value, // Now properly updates
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset(
                          'assets/logo_clear.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 0),
                    Opacity(
                      opacity: _opacityAnimation.value,
                      child: Text(
                        "ATL blog",
                        style: GoogleFonts.instrumentSans(
                          fontSize: 31,
                          fontWeight: FontWeight.w900,
                          color: Color(0xffa38300),
                        ),
                      ),
                    ),
                    // Spacer(),
                    SizedBox(height: 100),
                    Opacity(
                      opacity: _opacityAnimation.value,
                      child: Text(
                        "Made with ❤️",
                        style: GoogleFonts.instrumentSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w100,
                          color: Color(0xFF212121),
                        ),
                      )
                    ),
                    Opacity(
                        opacity: _opacityAnimation.value,
                        child: Text(
                          "Krishna Naveen 🇮🇳",
                          style: GoogleFonts.instrumentSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF212121),
                          ),
                        )
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
