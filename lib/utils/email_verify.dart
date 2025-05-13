import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class EmailVerificationPage extends StatefulWidget {
  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool _showSuccessAnimation = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
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

  Future<void> _refreshUserData() async {
    await _auth.currentUser?.reload();
    _user = _auth.currentUser;

    if (_user != null) {
      if (_user!.emailVerified) {
        await _dbRef.child('users/${_user!.uid}/email_verified').set(true);
        setState(() {
          _isEmailVerified = true;
          _showSuccessAnimation = true;
        });
      } else {
        final snapshot = await _dbRef.child('users/${_user!.uid}/email_verified').get();
        final savedStatus = snapshot.value == true;
        setState(() {
          _isEmailVerified = savedStatus;
          _showSuccessAnimation = savedStatus;
        });
      }
    }
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
        SnackBar(content: Text('Verification email sent! Check your inbox.')),
      );

      _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
        await _user!.reload();
        if (_user!.emailVerified) {
          timer.cancel();
          await _dbRef.child('users/${_user!.uid}/email_verified').set(true);
          setState(() {
            _isEmailVerified = true;
            _showSuccessAnimation = true;
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

  Future<bool> _onBackPressed() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you Sure?'),
        content: Text('Are you sure you want to go back?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Exit'),
          ),
        ],
      ),
    ) ??
        false;
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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          title: Text(
            'Verify Your Email',
            style: GoogleFonts.instrumentSans(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: textColor,
            ),
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _refreshUserData();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              // height: MediaQuery.of(context).size.height - kToolbarHeight,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80,),
                  if (_showSuccessAnimation)
                    Lottie.asset(
                      'assets/email_conf.json',
                      repeat: false,
                      width: 250,
                      height: 250,
                    ),
                  Text(
                    _isEmailVerified
                        ? "Your email has been verified!"
                        : _hasSentEmail
                        ? "A verification email has been sent to:"
                        : "Click the button below to receive a verification email:",
                    style: GoogleFonts.instrumentSans(
                        fontSize: 18, color: textColor),
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
                  if (!_isEmailVerified && !_hasSentEmail)
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
                          "Didn't receive an email? Check your spam folder.",
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
                    _buildButton('Continue to Tinker', goBack: true),
                  ],
                  SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Back to Profile",
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
      ),
    );
  }

  Widget _buildButton(String label, {bool goBack = false}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        minimumSize: Size(double.infinity, 50),
      ),
      onPressed: _isLoading || (_isButtonDisabled && !goBack)
          ? null
          : () {
        if (goBack) {
          Navigator.pop(context);
        } else {
          _sendVerificationEmail();
        }
      },
      child: _isLoading && !goBack
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
