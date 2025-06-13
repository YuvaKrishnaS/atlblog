import 'dart:ui';
import 'package:atal_without_krishna/cards/tutorials_card.dart';
import 'package:atal_without_krishna/utils/theme_color.dart';
import 'package:atal_without_krishna/utils/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TutorialsPage extends StatefulWidget {
  const TutorialsPage({super.key});

  @override
  State<TutorialsPage> createState() => _TutorialsPageState();
}

class _TutorialsPageState extends State<TutorialsPage> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _searchController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _searchAnimation;

  // Search and filtering
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _searchQuery = '';
  bool _isSearching = false;
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';

  // Categories and difficulties
  final List<String> _categories = ['All', 'Arduino', 'Raspberry Pi', 'IoT', 'Sensors', 'Robotics', 'Programming'];
  final List<String> _difficulties = ['All', 'Beginner', 'Intermediate', 'Advanced'];

  // Refresh function
  Future<void> _refreshTutorials() async {
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _searchController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _searchController, curve: Curves.easeInOut),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();

    // Search listener
    _searchTextController.addListener(() {
      setState(() {
        _searchQuery = _searchTextController.text.trim();
        _isSearching = _searchQuery.isNotEmpty;
      });

      if (_isSearching && !_searchController.isCompleted) {
        _searchController.forward();
      } else if (!_isSearching && _searchController.isCompleted) {
        _searchController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _searchController.dispose();
    _searchTextController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: ThemeColors.getBackgroundColor(context),
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return _buildAppBar(themeProvider);
            },
            body: RefreshIndicator(
              onRefresh: _refreshTutorials,
              color: ThemeColors.getAccentColor(context),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(0.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildStatsSection(),
                        const SizedBox(height: 20),
                        _buildSearchSection(),
                        const SizedBox(height: 20),
                        _buildFilterSection(),
                        const SizedBox(height: 24),
                        _buildTutorialsSection(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildAppBar(ThemeProvider themeProvider) {
    final bool isDarkMode = themeProvider.isDarkMode;

    return [
      SliverAppBar(
        pinned: true,
        floating: true,
        backgroundColor: Color(0xfff5f6f7),
        expandedHeight: 100.0,
        elevation: 0,
        leading: IconButton(
          icon: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ThemeColors.getCardColor(context).withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: ThemeColors.getTextColor(context),
              size: 18,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [
                    Color(0xFF1A1A1A).withOpacity(0.9),
                    Color(0xFF2D2D2D).withOpacity(0.8),
                  ]
                      : [
                    Color(0xFFFCFDFD).withOpacity(0.9),
                    Color(0xFFFFFFFF).withOpacity(0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border(
                  bottom: BorderSide(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                    width: 0.5,
                  ),
                ),
              ),
              child: FlexibleSpaceBar(
                title: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Hero(
                    tag: 'tutorialsHero',
                    child: Text(
                      'Tutorials',
                      style: GoogleFonts.kanit(
                        color: ThemeColors.getTextColor(context),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                centerTitle: true,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ThemeColors.getCardColor(context).withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.bookmark_border,
                color: ThemeColors.getAccentColor(context),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    ];
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Total',
                count: '24',
                icon: Icons.library_books_outlined,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Completed',
                count: '8',
                icon: Icons.check_circle_outline,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Favorites',
                count: '12',
                icon: Icons.favorite_border,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).isDarkMode
                ? Colors.black26
                : Colors.grey.withOpacity(0.2),
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: GoogleFonts.instrumentSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ThemeColors.getTextColor(context),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.instrumentSans(
              fontSize: 12,
              color: ThemeColors.getSecondaryTextColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: ThemeColors.getCardColor(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).isDarkMode
                  ? Colors.black26
                  : Colors.grey.withOpacity(0.2),
              blurRadius: 8.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedRotation(
              turns: _isSearching ? 0.5 : 0,
              duration: Duration(milliseconds: 300),
              child: Icon(
                Icons.search,
                color: ThemeColors.getAccentColor(context),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchTextController,
                focusNode: _focusNode,
                style: GoogleFonts.instrumentSans(
                  fontSize: 16,
                  color: ThemeColors.getTextColor(context),
                ),
                cursorColor: ThemeColors.getAccentColor(context),
                decoration: InputDecoration(
                  hintText: 'Search tutorials, topics, or keywords...',
                  hintStyle: GoogleFonts.instrumentSans(
                    fontSize: 16,
                    color: ThemeColors.getSecondaryTextColor(context),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            AnimatedScale(
              scale: _isSearching ? 1.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: GestureDetector(
                onTap: () {
                  _searchTextController.clear();
                  _focusNode.unfocus();
                },
                child: Icon(
                  Icons.clear_rounded,
                  color: ThemeColors.getSecondaryTextColor(context),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Filter by Category',
            style: GoogleFonts.instrumentSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ThemeColors.getTextColor(context),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category;

              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ThemeColors.getAccentColor(context)
                          : ThemeColors.getCardColor(context),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: ThemeColors.getAccentColor(context).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ] : [],
                    ),
                    child: Text(
                      category,
                      style: GoogleFonts.instrumentSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : ThemeColors.getTextColor(context),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Difficulty Level',
            style: GoogleFonts.instrumentSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ThemeColors.getTextColor(context),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _difficulties.length,
            itemBuilder: (context, index) {
              final difficulty = _difficulties[index];
              final isSelected = _selectedDifficulty == difficulty;

              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDifficulty = difficulty;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _getDifficultyColor(difficulty)
                          : ThemeColors.getCardColor(context),
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected ? null : Border.all(
                        color: _getDifficultyColor(difficulty).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      difficulty,
                      style: GoogleFonts.instrumentSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : _getDifficultyColor(difficulty),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'Advanced':
        return Colors.red;
      default:
        return ThemeColors.getAccentColor(context);
    }
  }

  Widget _buildTutorialsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Tutorials',
                style: GoogleFonts.instrumentSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: ThemeColors.getTextColor(context),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ThemeColors.getAccentColor(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '24 tutorials',
                  style: GoogleFonts.instrumentSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ThemeColors.getAccentColor(context),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Enhanced TutorialsList with filtering
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TutorialsList(
            searchQuery: _searchQuery,
            // selectedCategory: _selectedCategory,
            // selectedDifficulty: _selectedDifficulty,
          ),
        ),
      ],
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
              description: data[''] ?? '',
              authorName: data['author'] ?? '',
              category: data['category'] ?? '',
              difficulty: data['difficulty'] ?? '',
              duration: 2,
              views: 125,
              rating: 2,
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
