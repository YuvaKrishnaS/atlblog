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
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail Image with modern styling
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

                  // Author + Title row with modern spacing
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
                            radius: 21,
                            backgroundColor: isDarkMode ? Color(0xFF404040) : Color(0xFFF0F0F0),
                            child: CircleAvatar(
                              radius: 19,
                              backgroundImage: MemoryImage(authorImageBytes),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            title,
                            style: fontChoice.copyWith(
                              fontSize: 15.5,
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

                  const SizedBox(height: 8),
                ],
              ),
            ),

            // Modern bookmark icon
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.6)
                      : Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.bookmark_border,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.8)
                        : Color(0xFF666666),
                    size: 22,
                  ),
                  onPressed: () {
                    // Bookmark functionality here
                  },
                ),
              ),
            ),

            // Modern latest upload badge
            if (isRecentUpload)
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [Color(0xFF4CAF50), Color(0xFF2E7D32)]
                          : [Color(0xFF66BB6A), Color(0xFF4CAF50)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF4CAF50).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "Latest upload",
                    style: GoogleFonts.instrumentSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.2,
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
  final String searchQuery;

  const TutorialsList({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('blogs')
          .orderBy('createdAt', descending: true)
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
              "No tutorials found.",
              style: GoogleFonts.instrumentSans(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          );
        }

        final tutorials = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final title = data['title']?.toString().toLowerCase() ?? '';
          final author = data['author']?.toString().toLowerCase() ?? '';
          final query = searchQuery.toLowerCase();

          return query.isEmpty || title.contains(query) || author.contains(query);
        }).toList();

        if (tutorials.isEmpty) {
          return Center(
            child: Text(
              "No results match your search.",
              style: GoogleFonts.instrumentSans(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          );
        }

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
                // Navigate to detail page
              },
            );
          },
        );
      },
    );
  }
}