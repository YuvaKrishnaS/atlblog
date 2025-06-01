import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LatestPostCard extends StatelessWidget {
  final String title;
  final String authorImageBase64;
  final String thumbnailBase64;

  const LatestPostCard({
    Key? key,
    required this.title,
    required this.thumbnailBase64,
    required this.authorImageBase64,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uint8List thumbnailBytes = base64Decode(thumbnailBase64);
    Uint8List authorImageBytes = base64Decode(authorImageBase64);
    final TextStyle fontChoice = GoogleFonts.instrumentSans();
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
            Color(0xFF2A2A2A),
            Color(0xFF1F1F1F),
          ]
              : [
            Color(0xFFFFFFFF),
            Color(0xFFF8F9FA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.15),
            blurRadius: 15.0,
            offset: Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: isDarkMode
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.8),
            blurRadius: 5.0,
            offset: Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with modern styling
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.memory(
                  thumbnailBytes,
                  height: 175,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Author & Title Row with modern spacing
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Colors.black.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: isDarkMode ? Color(0xFF404040) : Color(0xFFF0F0F0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: MemoryImage(authorImageBytes),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Title text with modern typography
                  Expanded(
                    child: Text(
                      title,
                      style: fontChoice.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.95)
                            : Color(0xFF1A1A1A),
                        height: 1.3,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LatestPostsList extends StatelessWidget {
  const LatestPostsList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('blogs')
          .orderBy('createdAt', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No recent tutorials found.",
              style: GoogleFonts.instrumentSans(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          );
        }

        final blogs = snapshot.data!.docs;

        return Column(
          children: blogs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return LatestPostCard(
              title: data['title'] ?? '',
              thumbnailBase64: data['thumbnail'] ?? '',
              authorImageBase64: data['authorImage'] ?? '',
            );
          }).toList(),
        );
      },
    );
  }
}