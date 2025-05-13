import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnBasicsScreen extends StatefulWidget {
  const LearnBasicsScreen({super.key});

  @override
  State<LearnBasicsScreen> createState() => _LearnBasicsScreenState();
}

class _LearnBasicsScreenState extends State<LearnBasicsScreen> {
  final Map<String, String> videoLinks = {
    "Kickstart Coding": "https://youtu.be/ToZSFHUJdHM?si=WhewLX-O2KYVWocw",
    "Learn Python": "https://youtu.be/vLqTf2b6GZw?si=_fpzH2z20-Of21Qc",
    "Meet Arduino": "https://youtu.be/qWxGIH0y06c?si=32HNArV-C4Oshsy8",
    "First Project": "https://www.youtube.com/watch?v=w4lnVx2BAYk",
    "Level Up": "https://www.youtube.com/watch?v=Z1Yd7upQsXY",
    "Pro Tips": "https://www.youtube.com/watch?v=8jLOx1hD3_o",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffcfdfd),
      appBar: AppBar(
        backgroundColor: const Color(0xfffcfdfd),
        title: Text(
          'Learn the Basics',
          style: GoogleFonts.instrumentSans(
            color: const Color(0xff212121),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: videoLinks.entries.map((entry) {
          return Column(
            children: [
              buildLearningCard(
                title: entry.key,
                gradient: _getGradient(entry.key),
                onTap: () => _onCardTap(context, entry.key),
              ),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget buildLearningCard({
    required String title,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(32),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: GoogleFonts.instrumentSans(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Gradient _getGradient(String title) {
    switch (title) {
      case "Kickstart Coding":
        return const LinearGradient(
          colors: [Color(0xFFB0D686), Color(0xFF02407A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case "Learn Python":
        return const LinearGradient(
          colors: [Color(0xFFA8C0C4), Color(0xFF5B7278)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case "Meet Arduino":
        return const LinearGradient(
          colors: [Color(0xFFC2A7F2), Color(0xFFFDD4EC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case "First Project":
        return const LinearGradient(
          colors: [Color(0xFFFFE176), Color(0xFFFF7B36)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case "Level Up":
        return const LinearGradient(
          colors: [Color(0xFF654EA3), Color(0xFFEAAFC8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case "Pro Tips":
        return const LinearGradient(
          colors: [Color(0xff34e89e), Color(0xff1c3f4c)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Colors.grey, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  void _onCardTap(BuildContext context, String title) async {
    final url = videoLinks[title];

    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No video link available.")),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xfffcfdfd),
        title: Text("Open YouTube?", style: GoogleFonts.instrumentSans(
          color: const Color(0xff212121),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        )),
        content: Text("Do you want to open \"$title\" on YouTube?",
            style: GoogleFonts.instrumentSans()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel",
              style: GoogleFonts.kanit(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffc89b3c),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text("Yes, Open",
              style: GoogleFonts.kanit(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _launchYouTube(url);
    }
  }

  Future<void> _launchYouTube(String url) async {
    final uri = Uri.parse(url);

    try {
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched) {
          _showError("Unable to launch YouTube.");
        }
      } else {
        _showError("Cannot open the link.");
      }
    } catch (e) {
      _showError("Error: ${e.toString()}");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
