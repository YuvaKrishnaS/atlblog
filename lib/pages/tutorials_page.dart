import 'dart:ui';

import 'package:atal_without_krishna/cards/tutorials_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TutorialsPage extends StatefulWidget {
  const TutorialsPage({super.key});

  @override
  State<TutorialsPage> createState() => _TutorialsPageState();
}

class _TutorialsPageState extends State<TutorialsPage> {
  Future<void> _refreshTutorials() async {
    // Use setState to trigger a rebuild — ideal for StreamBuilder
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500)); // Optional delay
  }
  final Color primaryColor = Color(0xFF192841); // Deep Navy Blue
  final Color secondaryColor = Color(0xFFa38d42); // Muted Gold
  final Color neutralColor = Color(0xfff0f4f5); // Off-White
  final Color accentColor = Color(0xFFc89b3c); // Brighter Gold
  final Color textColor = Color(0xFF212121); // Very Dark Gray
  final Color IconColor = Color(0xFF535353);
  final Color backgroundColor = Color(0xfffcfdfd); // Simple White

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              backgroundColor: Colors.transparent, // Fully transparent
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Tutorials',
                style: GoogleFonts.instrumentSans(
                  color: Colors.black87,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.bookmark_border, color: Colors.black87),
                  onPressed: () {
                    // Placeholder for bookmark functionality
                  },
                ),
              ],
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent, // Frosted overlay tint
                ),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTutorials,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Ensures pull-to-refresh even with fewer items
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              TutorialsList(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
