import 'dart:ui';
import 'package:atal_without_krishna/firebase_auth_sevices.dart';
import 'package:atal_without_krishna/login_page.dart';
import 'package:atal_without_krishna/utils/post_register_email_verify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Circle positions
  double _topSmallCircle = 5; // Starts off-screen
  double _topBigCircle = -230;
  double _bottomBigCircle = 20;
  double _bottomCircle = -180;
  double _bottomRightCircle = 800;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final double spaceBetweenInputs = 10;

  String? _errorMessage; // To display validation error messages

  // ✅ Validate and Register
  void _register() {
    // Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match!";
      });
      return; // Stop execution if passwords do not match
    }

    // Clear error and continue with registration if valid
    setState(() {
      _errorMessage = null;
    });

    // Call Firebase Auth signup
    AuthService().signup(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
      context: context, // Pass context to navigate
    );
    // Navigator.push(context, PostRegisterEmailVerificationPage() as Route<Object?>);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'start',
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade200.withOpacity(0),
          elevation: 0,
          title: Text(
            'Register',
            style: GoogleFonts.instrumentSans(
              fontWeight: FontWeight.w700
            ),
          ),

        ),
        //Background color
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              top: -110+210,
              right: -100,
              child: Container(
                width: 190,
                height: 190,
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
            Positioned(
              top: -110,
              right: -160,
              child: Container(
                width: 300,
                height: 300,
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
            Positioned(
              bottom: -50,
              right: -55,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xff2DFF03), Color(0xFF5296B9)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -130,
              left: -155,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF5C79EC), Color(0xFFFF0303)],
                    begin: Alignment.bottomRight,
                    end: Alignment.centerLeft,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 25),
                child: Container(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          child: Lottie.asset(
                            'assets/regist.json',
                            height: 150
                            // fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 0.0),
                      // Welcome Text
                      Text(
                        "Start your Journey",
                        style: GoogleFonts.instrumentSans(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 30),
                      // Name TextField
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          suffixStyle: GoogleFonts.instrumentSans(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          hintText: "Full Name",
                          prefixIcon: Icon(LineAwesomeIcons.user),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Color(0xFF212121)
                            ),
                          ),
                        ),
                        style: GoogleFonts.instrumentSans(),
                      ),
                      SizedBox(height: spaceBetweenInputs),
                      // Email TextField
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(LineAwesomeIcons.envelope_solid),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Color(0xFF212121)
                            ),
                          ),
                        ),
                        style: GoogleFonts.instrumentSans(),
                      ),
                      SizedBox(height: spaceBetweenInputs),
                      // Password TextField with Eye Icon
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(LineAwesomeIcons.fingerprint_solid),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Color(0xFF212121),
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        style: GoogleFonts.instrumentSans(),
                      ),
                      SizedBox(height: spaceBetweenInputs),
                      // Confirm Password TextField with Eye Icon
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          prefixIcon: Icon(Icons.lock_outline),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Color(0xff212121)
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        style: GoogleFonts.instrumentSans(),
                      ),
                      SizedBox(height: 5),
                      // Error Message (if any)
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            _errorMessage!,
                            style: GoogleFonts.instrumentSans(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      SizedBox(height: 10),
                      // Register Button
                      ElevatedButton(
                        onPressed: _register, // Call the register function
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(
                          "Register",
                          style: GoogleFonts.instrumentSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "or",
                        style: GoogleFonts.instrumentSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: AuthService().signInWithGoogle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: Color(0xff212121)
                            )
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          minimumSize: Size(double.infinity, 50),
                          elevation: 0, // Optional: Add shadow
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Google Logo
                            Image.asset(
                              'assets/google_logo.png', // Add your logo in assets
                              height: 24,
                              width: 24,
                            ),
                            SizedBox(width: 10),

                            // Button Text
                            Text(
                              'Continue with Google',
                              style: GoogleFonts.instrumentSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff212121),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
