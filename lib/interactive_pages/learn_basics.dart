import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

// Import your theme files
import 'package:atal_without_krishna/utils/theme_color.dart';
import 'package:atal_without_krishna/utils/theme_provider.dart';

class LearnBasicsScreen extends StatefulWidget {
  const LearnBasicsScreen({super.key});

  @override
  State<LearnBasicsScreen> createState() => _LearnBasicsScreenState();
}

class _LearnBasicsScreenState extends State<LearnBasicsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  // Progress tracking
  Set<int> completedSteps = {};
  int currentStep = 0;

  final List<RoadmapStep> roadmapSteps = [
    RoadmapStep(
      title: "Kickstart Coding",
      subtitle: "Begin your coding journey",
      description: "Learn the fundamentals of programming and get ready to create amazing projects!",
      videoUrl: "https://youtu.be/ToZSFHUJdHM?si=WhewLX-O2KYVWocw",
      color: const Color(0xFF6C5CE7),
      icon: Icons.rocket_launch,
    ),
    RoadmapStep(
      title: "Learn Python",
      subtitle: "Master the basics",
      description: "Dive deep into Python programming language and understand core concepts.",
      videoUrl: "https://youtu.be/vLqTf2b6GZw?si=_fpzH2z20-Of21Qc",
      color: const Color(0xFF00B894),
      icon: Icons.code,
    ),
    RoadmapStep(
      title: "Meet Arduino",
      subtitle: "Hardware programming",
      description: "Get introduced to Arduino and learn how to program microcontrollers.",
      videoUrl: "https://youtu.be/qWxGIH0y06c?si=32HNArV-C4Oshsy8",
      color: const Color(0xFFE17055),
      icon: Icons.developer_board,
    ),
    RoadmapStep(
      title: "First Project",
      subtitle: "Build something real",
      description: "Create your first real-world project and see your skills in action!",
      videoUrl: "https://www.youtube.com/watch?v=w4lnVx2BAYk",
      color: const Color(0xFFFFD93D),
      icon: Icons.build,
    ),
    RoadmapStep(
      title: "Level Up",
      subtitle: "Advanced concepts",
      description: "Take your skills to the next level with advanced programming techniques.",
      videoUrl: "https://www.youtube.com/watch?v=Z1Yd7upQsXY",
      color: const Color(0xFFFF6B6B),
      icon: Icons.trending_up,
    ),
    RoadmapStep(
      title: "Pro Tips",
      subtitle: "Expert knowledge",
      description: "Learn professional tips and tricks to become a coding expert.",
      videoUrl: "https://www.youtube.com/watch?v=8jLOx1hD3_o",
      color: const Color(0xFF4ECDC4),
      icon: Icons.star,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final completedList = prefs.getStringList('completed_steps') ?? [];
    final current = prefs.getInt('current_step') ?? 0;

    setState(() {
      completedSteps = completedList.map((e) => int.parse(e)).toSet();
      currentStep = current;
    });
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('completed_steps',
        completedSteps.map((e) => e.toString()).toList());
    await prefs.setInt('current_step', currentStep);
  }

  void _markStepCompleted(int stepIndex) {
    setState(() {
      completedSteps.add(stepIndex);
      if (stepIndex == currentStep && currentStep < roadmapSteps.length - 1) {
        currentStep = stepIndex + 1;
      }
    });
    _saveProgress();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.getBackgroundColor(context),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildRoadmapContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: ThemeColors.getBackgroundColor(context),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Learning Roadmap',
          style: GoogleFonts.instrumentSans(
            color: ThemeColors.getTextColor(context),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ThemeColors.getAccentColor(context).withOpacity(0.3),
                ThemeColors.getBackgroundColor(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoadmapContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _buildProgressIndicator(),
          const SizedBox(height: 30),
          ...roadmapSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return _buildRoadmapItem(step, index);
          }).toList(),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final progress = completedSteps.length / roadmapSteps.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.getCardColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Progress',
                style: GoogleFonts.instrumentSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ThemeColors.getTextColor(context),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.instrumentSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.getAccentColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween(begin: 0.0, end: progress),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                backgroundColor: ThemeColors.getSecondaryTextColor(context).withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  ThemeColors.getAccentColor(context),
                ),
                minHeight: 8,
              );
            },
          ),
          const SizedBox(height: 10),
          Text(
            '${completedSteps.length} of ${roadmapSteps.length} steps completed',
            style: GoogleFonts.instrumentSans(
              fontSize: 14,
              color: ThemeColors.getSecondaryTextColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapItem(RoadmapStep step, int index) {
    final isCompleted = completedSteps.contains(index);
    final isCurrent = index == currentStep;
    final isLocked = index > currentStep && !isCompleted;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: animationValue,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepIndicator(step, index, isCompleted, isCurrent, isLocked),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildStepCard(step, index, isCompleted, isCurrent, isLocked),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepIndicator(RoadmapStep step, int index, bool isCompleted, bool isCurrent, bool isLocked) {
    Widget indicator;

    if (isCompleted) {
      indicator = Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 24),
      );
    } else if (isCurrent) {
      indicator = AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: step.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: step.color.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Icon(step.icon, color: Colors.white, size: 24),
            ),
          );
        },
      );
    } else if (isLocked) {
      indicator = Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: ThemeColors.getSecondaryTextColor(context).withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.lock,
          color: ThemeColors.getSecondaryTextColor(context),
          size: 24,
        ),
      );
    } else {
      indicator = Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: step.color.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        child: Icon(step.icon, color: Colors.white, size: 24),
      );
    }

    return Column(
      children: [
        indicator,
        if (index < roadmapSteps.length - 1)
          Container(
            width: 2,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  isCompleted ? Colors.green : step.color,
                  isCompleted || index < currentStep
                      ? (index + 1 < roadmapSteps.length && completedSteps.contains(index + 1)
                      ? Colors.green
                      : roadmapSteps[index + 1].color)
                      : ThemeColors.getSecondaryTextColor(context).withOpacity(0.3),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStepCard(RoadmapStep step, int index, bool isCompleted, bool isCurrent, bool isLocked) {
    return GestureDetector(
      onTap: isLocked ? null : () => _showStepBottomSheet(step, index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ThemeColors.getCardColor(context),
          borderRadius: BorderRadius.circular(20),
          border: isCurrent
              ? Border.all(color: step.color, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: isLocked
                  ? Colors.transparent
                  : (isCurrent ? step.color : Colors.black).withOpacity(0.1),
              blurRadius: isCurrent ? 15 : 10,
              offset: const Offset(0, 5),
              spreadRadius: isCurrent ? 2 : 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    step.title,
                    style: GoogleFonts.instrumentSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isLocked
                          ? ThemeColors.getSecondaryTextColor(context)
                          : ThemeColors.getTextColor(context),
                    ),
                  ),
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Completed',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                if (isCurrent && !isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: step.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Current',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: step.color,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              step.subtitle,
              style: GoogleFonts.instrumentSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: step.color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              step.description,
              style: GoogleFonts.instrumentSans(
                fontSize: 14,
                color: isLocked
                    ? ThemeColors.getSecondaryTextColor(context)
                    : ThemeColors.getSecondaryTextColor(context),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStepBottomSheet(RoadmapStep step, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildStepBottomSheet(step, index),
    );
  }

  Widget _buildStepBottomSheet(RoadmapStep step, int index) {
    final isCompleted = completedSteps.contains(index);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: ThemeColors.getCardColor(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: ThemeColors.getSecondaryTextColor(context).withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: step.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                step.icon,
                size: 40,
                color: step.color,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              step.title,
              style: GoogleFonts.instrumentSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ThemeColors.getTextColor(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              step.subtitle,
              style: GoogleFonts.instrumentSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: step.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              step.description,
              style: GoogleFonts.instrumentSans(
                fontSize: 16,
                color: ThemeColors.getSecondaryTextColor(context),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: step.color),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: step.color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _launchVideo(step.videoUrl, index);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: step.color,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isCompleted ? Icons.replay : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isCompleted ? 'Watch Again' : 'Start Learning',
                          style: GoogleFonts.instrumentSans(
                            fontSize: 16,
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
          ],
        ),
      ),
    );
  }

  Future<void> _launchVideo(String url, int stepIndex) async {
    final uri = Uri.parse(url);

    try {
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (launched) {
          // Mark step as completed when video is launched
          _markStepCompleted(stepIndex);

          // Show completion snackbar
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Great! Step completed. Keep going!',
                  style: GoogleFonts.instrumentSans(),
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        } else {
          _showError("Unable to launch video.");
        }
      } else {
        _showError("Cannot open the video link.");
      }
    } catch (e) {
      _showError("Error: ${e.toString()}");
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}

class RoadmapStep {
  final String title;
  final String subtitle;
  final String description;
  final String videoUrl;
  final Color color;
  final IconData icon;

  RoadmapStep({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.videoUrl,
    required this.color,
    required this.icon,
  });
}