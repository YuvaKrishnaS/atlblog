import 'package:flutter/material.dart';

class KickstartCode extends StatefulWidget {
  const KickstartCode({super.key});

  @override
  State<KickstartCode> createState() => _KickstartCodeState();
}

class _KickstartCodeState extends State<KickstartCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kickstart Coding !'),
        centerTitle: true,
      ),
      body: Hero(
        tag: 'card_learn',
        child: Center(
          child: Text('Kickstart Coding !'),
        ),
      ),
    );
  }
}
