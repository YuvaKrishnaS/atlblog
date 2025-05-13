import 'dart:convert';
import 'package:flutter/material.dart';

class TutorialCard extends StatelessWidget {
  final String title;
  final String author;
  final String category;
  final String? base64Thumbnail;
  final DateTime? timestamp;
  final VoidCallback onTap;

  const TutorialCard({
    super.key,
    required this.title,
    required this.author,
    required this.category,
    this.base64Thumbnail,
    this.timestamp,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = base64Thumbnail != null && base64Thumbnail!.isNotEmpty
        ? Image.memory(
      base64Decode(base64Thumbnail!),
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    )
        : Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.image, size: 40, color: Colors.white),
    );

    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageWidget,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "By $author",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (timestamp != null)
                        Text(
                          "${timestamp!.day}/${timestamp!.month}/${timestamp!.year}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}