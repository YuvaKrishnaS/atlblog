import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TutorialCard extends StatelessWidget {
  final String title;
  final String authorImageBase64;
  final String thumbnailBase64;
  final DateTime? timestamp;
  final VoidCallback onTap;

  const TutorialCard({
    Key? key,
    required this.title,
    required this.thumbnailBase64,
    required this.authorImageBase64,
    this.timestamp,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Uint8List thumbnailBytes = base64Decode(thumbnailBase64);
    final Uint8List authorImageBytes = base64Decode(authorImageBase64);
    final bool isRecentUpload =
        timestamp != null && DateTime.now().difference(timestamp!).inHours < 24;

    final TextStyle fontChoice = GoogleFonts.instrumentSans();
    final Color textColor = const Color(0xff0d1b2a);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xffeae9e9),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail Image
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

                  // Author + Title row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: MemoryImage(authorImageBytes),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            title,
                            style: fontChoice.copyWith(
                              fontSize: 15,
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

                  const SizedBox(height: 6),
                ],
              ),
            ),

            // Bookmark icon
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {
                    // Bookmark functionality here
                  },
                ),
              ),
            ),

            // Latest upload badge
            if (isRecentUpload)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0XFFFFFFFF), Colors.grey.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Latest upload",
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
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

class TutorialsList extends StatelessWidget {
  const TutorialsList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('blogs')
          .orderBy('createdAt', descending: true)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No tutorials found."));
        }

        final tutorials = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tutorials.length,
          itemBuilder: (context, index) {
            final data = tutorials[index].data() as Map<String, dynamic>;

            return TutorialCard(
              title: data['title'] ?? '',
              thumbnailBase64: data['thumbnail'] ?? '',
              authorImageBase64: data['authorImage'] ?? '',
              timestamp: (data['createdAt'] as Timestamp?)?.toDate(),
              onTap: () {
                // Navigate to detail page or perform action
              },
            );
          },
        );
      },
    );
  }
}
