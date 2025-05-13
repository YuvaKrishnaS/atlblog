import 'dart:ui';
import 'package:atal_without_krishna/firebase_auth_sevices.dart';
import 'package:atal_without_krishna/register_page.dart';
import 'package:atal_without_krishna/welcome_slides.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode(); // To track email focus
  bool _obscurePassword = true;
  bool _showClearIcon = false; // Track if clear icon should show

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkClearIcon); // Listen to changes
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Check if clear icon should be shown
  void _checkClearIcon() {
    setState(() {
      _showClearIcon = _emailController.text.isNotEmpty;
    });
  }

  // Clear email input
  void _clearEmail() {
    _emailController.clear();
    setState(() {
      _showClearIcon = false;
    });
  }

  // Dismiss keyboard on tap outside
  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  Future<void> _login() async {
    await AuthService().signin(
        email: _emailController.text,
        password: _passwordController.text,
        context: context
    );
  }


  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'login',
      child: GestureDetector(
        onTap: _dismissKeyboard,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.grey.shade200.withOpacity(0),
            elevation: 0,
            title: Text(
              'Login',
              style: GoogleFonts.instrumentSans(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned(
                top: -110 + 210,
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
                              'assets/register_ani.json',
                              height: 150,
                            ),
                          ),
                        ),
                        SizedBox(height: 0.0),
                        // Welcome Text
                        Text(
                          "Welcome Back!",
                          style: GoogleFonts.instrumentSans(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 30),
                        // Email TextField
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color(0xFF212121),
                              )
                            ),
                            suffixIcon: _showClearIcon
                                ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey),
                              onPressed: _clearEmail,
                            ) : null,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }
                            return null;
                          },
                          style: GoogleFonts.instrumentSans(),
                        ),
                        SizedBox(height: 10),
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
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
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

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text(
                            "Login",
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
                          ),
                        ),
                        SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: AuthService().signInWithGoogle,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Color(0xff212121)),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            minimumSize: Size(double.infinity, 50),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/google_logo.png',
                                height: 24,
                                width: 24,
                              ),
                              SizedBox(width: 10),
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
      ),
    );
  }
}