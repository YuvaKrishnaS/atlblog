import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class PostRegisterEmailVerificationPage extends StatefulWidget {
  @override
  _PostRegisterEmailVerificationPageState createState() =>
      _PostRegisterEmailVerificationPageState();
}

class _PostRegisterEmailVerificationPageState
    extends State<PostRegisterEmailVerificationPage> {
  bool _showSuccessAnimation = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Timer? _timer;
  Timer? _cooldownTimer;
  bool _isEmailVerified = false;
  bool _isLoading = false;
  bool _hasSentEmail = false;
  bool _isButtonDisabled = false;
  int _secondsRemaining = 0;

  final Color backgroundColor = Color(0xfffcfdfd);
  final Color textColor = Color(0xFF212121);
  final Color accentColor = Color(0xFFc89b3c);

  @override
  void initState() {
    super.initState();
    _refreshUserData();
  }

  void _refreshUserData() async {
    await _auth.currentUser?.reload();
    setState(() {
      _user = _auth.currentUser;
      _isEmailVerified = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  Future<void> _sendVerificationEmail() async {
    setState(() {
      _isLoading = true;
      _isButtonDisabled = true;
      _secondsRemaining = 60;
    });

    try {
      await _user!.sendEmailVerification();
      setState(() {
        _hasSentEmail = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification email sent!')),
      );

      _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
        await _user!.reload();
        if (_user!.emailVerified) {
          timer.cancel();
          setState(() {
            _isEmailVerified = true;
            _showSuccessAnimation = true;
          });

          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _showSuccessAnimation = false;
            });
            Navigator.pushReplacementNamed(context, '/usercheck');
          });
        }
      });

      _cooldownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() {
            _secondsRemaining--;
          });
        } else {
          setState(() {
            _isButtonDisabled = false;
          });
          timer.cancel();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending email: $e')),
      );
      setState(() {
        _isButtonDisabled = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  String getMaskedEmail(String email) {
    List<String> parts = email.split('@');
    if (parts.length != 2) return email;

    String localPart = parts[0];
    String domain = parts[1];

    if (localPart.length <= 2) {
      return email;
    }

    return '${localPart[0]}******${localPart[localPart.length - 1]}@$domain';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Confirm Your Email',
          style: GoogleFonts.instrumentSans(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshUserData();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height - kToolbarHeight,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_showSuccessAnimation)
                  Lottie.asset(
                    'assets/email_conf.json',
                    repeat: false,
                    height: 150,
                  ),
                Text(
                  _isEmailVerified
                      ? "You're verified! Redirecting..."
                      : _hasSentEmail
                      ? "We’ve sent a confirmation link to:"
                      : "Verify your email to complete your registration",
                  style: GoogleFonts.instrumentSans(fontSize: 18, color: textColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  _user?.email != null
                      ? getMaskedEmail(_user!.email!)
                      : "Fetching email...",
                  style: GoogleFonts.instrumentSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),

                if (!_hasSentEmail)
                  _buildButton('Send Verification Email'),
                if (_hasSentEmail && !_isEmailVerified)
                  Column(
                    children: [
                      _buildButton('Resend Verification Email'),
                      if (_isButtonDisabled)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'You can resend in $_secondsRemaining seconds',
                            style: GoogleFonts.instrumentSans(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      SizedBox(height: 10),
                      Text(
                        "Didn’t receive it? Check your spam folder.",
                        style: GoogleFonts.instrumentSans(
                          fontSize: 14,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                if (_isEmailVerified) ...[
                  SizedBox(height: 20),
                  _buildButton('Continue', goToCheck: true),
                ],

                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/usercheck');
                  },
                  child: Text(
                    "Skip for now",
                    style: GoogleFonts.instrumentSans(
                      fontSize: 16,
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, {bool goToCheck = false}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        minimumSize: Size(double.infinity, 50),
      ),
      onPressed: _isLoading || (_isButtonDisabled && !goToCheck)
          ? null
          : () {
        if (goToCheck) {
          Navigator.pushReplacementNamed(context, '/usercheck');
        } else {
          _sendVerificationEmail();
        }
      },
      child: _isLoading && !goToCheck
          ? CircularProgressIndicator(color: Colors.white)
          : Text(
        label,
        style: GoogleFonts.instrumentSans(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
