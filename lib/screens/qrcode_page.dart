import 'package:flutter/material.dart';

class QrCodePage extends StatelessWidget {
  const QrCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(32),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: const Center(
                child: Text("PASS FESTIVALIER",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Icon(Icons.qr_code_2, size: 200), // Remplace par une vraie image de QR si besoin
            ),
            const Text("Jean Dupont", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text("Pass 3 Jours", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}