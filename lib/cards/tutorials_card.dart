import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:atal_without_krishna/utils/theme_color.dart';

class TutorialCard extends StatelessWidget {
  final String title;
  final String description;
  final String authorName;
  final String authorImageBase64;
  final String thumbnailBase64;
  final String category;
  final String difficulty;
  final int duration; // in minutes
  final double rating;
  final int views;
  final bool isBookmarked;
  final bool isCompleted;
  final List<String> tags;
  final DateTime? timestamp;
  final VoidCallback onTap;
  final VoidCallback? onBookmark;

  const TutorialCard({
    Key? key,
    required this.title,
    required this.description,
    required this.authorName,
    required this.thumbnailBase64,
    required this.authorImageBase64,
    required this.category,
    required this.difficulty,
    required this.duration,
    required this.rating,
    required this.views,
    this.isBookmarked = false,
    this.isCompleted = false,
    this.tags = const [],
    this.timestamp,
    required this.onTap,
    this.onBookmark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Uint8List thumbnailBytes = base64Decode(thumbnailBase64);
    final Uint8List authorImageBytes = base64Decode(authorImageBase64);
    final bool isRecentUpload =
        timestamp != null && DateTime.now().difference(timestamp!).inHours < 24;

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: ThemeColors.getCardColor(context),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail Image with overlay info
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 180,
                          width: double.infinity,
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
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Duration overlay
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${duration}min',
                            style: GoogleFonts.instrumentSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // Completed badge
                      if (isCompleted)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Completed',
                                  style: GoogleFonts.instrumentSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Category and Difficulty badges
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: ThemeColors.getAccentColor(context).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          category,
                          style: GoogleFonts.instrumentSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: ThemeColors.getAccentColor(context),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(difficulty).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          difficulty,
                          style: GoogleFonts.instrumentSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: _getDifficultyColor(difficulty),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Title
                  Text(
                    title,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: ThemeColors.getTextColor(context),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    description,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 14,
                      color: ThemeColors.getSecondaryTextColor(context),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Author and stats row
                  Row(
                    children: [
                      // Author avatar and name
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundImage: MemoryImage(authorImageBytes),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          authorName,
                          style: GoogleFonts.instrumentSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: ThemeColors.getTextColor(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Rating and views
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: GoogleFonts.instrumentSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: ThemeColors.getTextColor(context),
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(
                            Icons.visibility,
                            color: ThemeColors.getSecondaryTextColor(context),
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            _formatViews(views),
                            style: GoogleFonts.instrumentSans(
                              fontSize: 12,
                              color: ThemeColors.getSecondaryTextColor(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Tags (if available)
                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: tags.take(3).map((tag) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: ThemeColors.getSecondaryTextColor(context).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '#$tag',
                          style: GoogleFonts.instrumentSans(
                            fontSize: 10,
                            color: ThemeColors.getSecondaryTextColor(context),
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),

            // Bookmark button
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: onBookmark,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isBookmarked
                        ? ThemeColors.getAccentColor(context)
                        : ThemeColors.getCardColor(context).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: isBookmarked
                          ? ThemeColors.getAccentColor(context)
                          : Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked
                        ? Colors.white
                        : ThemeColors.getTextColor(context),
                    size: 20,
                  ),
                ),
              ),
            ),

            // Recent upload badge
            if (isRecentUpload && !isCompleted)
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
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
                    "New",
                    style: GoogleFonts.instrumentSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return views.toString();
  }
}

// Enhanced TutorialsList with proper filtering
class TutorialsList extends StatelessWidget {
  final String searchQuery;
  final String selectedCategory;
  final String selectedDifficulty;

  const TutorialsList({
    Key? key,
    required this.searchQuery,
    this.selectedCategory = 'All',
    this.selectedDifficulty = 'All',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _buildQuery(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  ThemeColors.getAccentColor(context),
                ),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(context, "No tutorials found.");
        }

        final filteredTutorials = _filterTutorials(snapshot.data!.docs);

        if (filteredTutorials.isEmpty) {
          return _buildEmptyState(context, "No tutorials match your filters.");
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredTutorials.length,
          itemBuilder: (context, index) {
            final data = filteredTutorials[index].data() as Map<String, dynamic>;

            return TutorialCard(
              title: data['title'] ?? 'Untitled Tutorial',
              description: data['description'] ?? 'No description available',
              authorName: data['authorName'] ?? 'Unknown Author',
              thumbnailBase64: data['thumbnail'] ?? '',
              authorImageBase64: data['authorImage'] ?? '',
              category: data['category'] ?? 'General',
              difficulty: data['difficulty'] ?? 'Beginner',
              duration: data['duration'] ?? 0,
              rating: (data['rating'] ?? 0.0).toDouble(),
              views: data['views'] ?? 0,
              isBookmarked: data['isBookmarked'] ?? false,
              isCompleted: data['isCompleted'] ?? false,
              tags: List<String>.from(data['tags'] ?? []),
              timestamp: (data['createdAt'] as Timestamp?)?.toDate(),
              onTap: () {
                // Navigate to tutorial detail page
                _navigateToTutorialDetail(context, filteredTutorials[index].id, data);
              },
              onBookmark: () {
                // Handle bookmark toggle
                _toggleBookmark(filteredTutorials[index].id, data['isBookmarked'] ?? false);
              },
            );
          },
        );
      },
    );
  }

  Stream<QuerySnapshot> _buildQuery() {
    Query query = FirebaseFirestore.instance.collection('blogs');

    // Apply category filter if not 'All'
    if (selectedCategory != 'All') {
      query = query.where('category', isEqualTo: selectedCategory);
    }

    // Apply difficulty filter if not 'All'
    if (selectedDifficulty != 'All') {
      query = query.where('difficulty', isEqualTo: selectedDifficulty);
    }

    // Order by creation date
    return query.orderBy('createdAt', descending: true).snapshots();
  }

  List<QueryDocumentSnapshot> _filterTutorials(List<QueryDocumentSnapshot> docs) {
    if (searchQuery.isEmpty) return docs;

    return docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final title = data['title']?.toString().toLowerCase() ?? '';
      final description = data['description']?.toString().toLowerCase() ?? '';
      final authorName = data['authorName']?.toString().toLowerCase() ?? '';
      final tags = List<String>.from(data['tags'] ?? []);
      final query = searchQuery.toLowerCase();

      return title.contains(query) ||
          description.contains(query) ||
          authorName.contains(query) ||
          tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 64,
              color: ThemeColors.getSecondaryTextColor(context),
            ),
            SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.instrumentSans(
                color: ThemeColors.getSecondaryTextColor(context),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTutorialDetail(BuildContext context, String tutorialId, Map<String, dynamic> data) {
    // Implement navigation to tutorial detail page
    print('Navigate to tutorial: $tutorialId');
    // Navigator.pushNamed(context, '/tutorial-detail', arguments: tutorialId);
  }

  void _toggleBookmark(String tutorialId, bool currentStatus) {
    // Update bookmark status in Firestore
    FirebaseFirestore.instance
        .collection('blogs')
        .doc(tutorialId)
        .update({'isBookmarked': !currentStatus});
  }
}