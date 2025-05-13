import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForYouCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String authorName;
  final String authorImagePath;

  ForYouCard({
    required this.imagePath,
    required this.title,
    required this.authorName,
    required this.authorImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle FontChoice = GoogleFonts.instrumentSans();
    final Color textColor = Color(0xff272727);

    return Container(
      width: 150, // Increased width for larger cards
      decoration: BoxDecoration(
        color: Color(0xfffaf6ed),
        // color: Colors.white,
        borderRadius: BorderRadius.circular(100.0),
        // boxShadow: [
        //   BoxShadow(
        //     color: Color(0xffe1e1e1),
        //     blurRadius: 3,
        //     offset: Offset(2, 0),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Padding(
            padding: const EdgeInsets.all(0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: Image.asset(
                imagePath,
                height: 200, // Adjusted height for larger image
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
