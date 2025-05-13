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
    final Color textColor = const Color(0xff0d1b2a);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xffeae9e9),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                thumbnailBytes,
                height: 175,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            // Author & Title Row
            // Author & Title Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 21,
                    backgroundImage: MemoryImage(authorImageBytes),
                  ),
                  const SizedBox(width: 12),
                  // Title text
                  Expanded(
                    child: Text(
                      title,
                      style: fontChoice.copyWith(
                        fontSize: 15.3,
                        fontWeight: FontWeight.w600,
                        color: textColor,
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
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("No recent tutorials found.");
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
