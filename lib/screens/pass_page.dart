import 'package:flutter/material.dart';

class PassPage extends StatelessWidget {
  const PassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Achat Pass")),
      body: const Center(child: Text("Billetterie du festival")),
    );
  }
}