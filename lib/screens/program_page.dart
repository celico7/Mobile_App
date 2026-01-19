import 'package:flutter/material.dart';

class ProgramPage extends StatelessWidget {
  const ProgramPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Programme")),
      body: const Center(child: Text("Calendrier des projections")),
    );
  }
}