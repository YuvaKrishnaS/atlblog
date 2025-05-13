import 'package:flutter/material.dart';

class TutorialsPage extends StatefulWidget {
  const TutorialsPage({super.key});

  @override
  State<TutorialsPage> createState() => _TutorialsPageState();
}

class _TutorialsPageState extends State<TutorialsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe5e7e9),
      appBar: AppBar(
        title: 
          Hero(
            tag: 'tutorialsHero',
            child: Text('Tutotials'),
          )
      ),
    );
  }
}


