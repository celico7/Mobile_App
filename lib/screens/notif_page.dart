import 'package:flutter/material.dart';

class NotifPage extends StatelessWidget {
  const NotifPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifs = [
      {"title": "ALERTE", "msg": "La séance de 20h est complète !", "icon": Icons.warning, "color": Colors.orange},
      {"title": "PROGRAMME", "msg": "Ajout d'une rencontre avec le réalisateur demain à 14h.", "icon": Icons.info, "color": Colors.blue},
      {"title": "BILLETTERIE", "msg": "Votre pass a été validé avec succès.", "icon": Icons.check_circle, "color": Colors.green},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifs.length,
      itemBuilder: (context, index) {
        final n = notifs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: n['color'].withOpacity(0.2),
              child: Icon(n['icon'], color: n['color']),
            ),
            title: Text(n['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            subtitle: Text(n['msg'], style: const TextStyle(fontSize: 14, color: Colors.black87)),
            trailing: const Text("12:30", style: TextStyle(fontSize: 10, color: Colors.grey)),
          ),
        );
      },
    );
  }
}