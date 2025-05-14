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
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
  }

  final Color primaryColor = const Color(0xFF192841);
  final Color backgroundColor = const Color(0xfffcfdfd);

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

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
              backgroundColor: Colors.transparent,
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
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTutorials,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        decoration: const InputDecoration(
                          hintText: 'Search tutorials...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (_focusNode.hasFocus && _searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          FocusScope.of(context).unfocus(); // Hide keyboard
                        },
                        child: const Icon(Icons.clear, color: Colors.grey),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tutorials List
              TutorialsList(searchQuery: _searchQuery),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
