import 'package:atal_without_krishna/login_page.dart';
import 'package:atal_without_krishna/register_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';

class GetStartedPage extends StatelessWidget {
  @override
  void _navigateWithAnimation(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1000),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.00);
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Exit the app on back press
        SystemNavigator.pop();
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background Lottie Animation
            Positioned.fill(
              child: Lottie.asset(
                'assets/back.json',
                fit: BoxFit.cover,
              ),
            ),

            // Main Content
            Column(
              children: [
                Spacer(),

                // Left-aligned Texts
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Heading
                      Text(
                        "Mix with Technology",
                        style: GoogleFonts.instrumentSans(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: Color(0xffffffff),
                        ),
                      ),
                      SizedBox(height: 10),

                      // Subheading
                      Text(
                        "Start Tinkering with Technology",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.instrumentSans(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),

                // Bottom Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Get Started Button
                      Hero(
                        tag: 'start',
                        child: ElevatedButton(
                          onPressed: () {
                            _navigateWithAnimation(context, RegisterScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: Text(
                            "Get Started",
                            style: GoogleFonts.instrumentSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      Spacer(),

                      // Login Button
                      Hero(
                        tag: 'login',
                        child: ElevatedButton(
                          onPressed: () {
                            _navigateWithAnimation(context, LoginScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: Text(
                            "Login",
                            style: GoogleFonts.instrumentSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
