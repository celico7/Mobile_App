import 'package:flutter/material.dart';
import 'home_page.dart';
import 'program_page.dart';
import 'pass_page.dart';
// N'oublie pas de créer ces fichiers ou de vérifier les noms
import 'quotidienne_page.dart';
import 'notif_page.dart';
import 'qrcode_page.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  // IMPORTANTE : La liste doit avoir exactement le même nombre
  // d'éléments que ton menu (6 destinations = 6 pages)
  final List<Widget> _pages = [
    const HomePage(),
    const ProgramPage(),
    const PassPage(),
    const QuotidiennePage(), // Index 3
    const NotifPage(),       // Index 4
    const QrCodePage(),      // Index 5
  ];

  final List<String> _titles = [
    "FEFFS",
    "Programme",
    "Achat Pass",
    "Quotidienne",
    "Notifications",
    "Mon QR Code"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/images/logo_festival.png',
              height: 32,
              errorBuilder: (c, o, s) => const Icon(Icons.music_note),
            ),
          ),
        ],
      ),

      drawer: NavigationDrawer(
        selectedIndex: _selectedIndex,
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          Navigator.pop(context);
        },
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 32, 16, 20),
            child: Row(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    'assets/images/logo_festival.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.music_note, size: 50),
                  ),
                ),
              ],
            ),
          ),

          const NavigationDrawerDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: Text("Accueil"),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: Text("Programme"),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.confirmation_number_outlined),
            selectedIcon: Icon(Icons.confirmation_number),
            label: Text("Achat Pass"),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),

          const NavigationDrawerDestination(
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today),
            label: Text("Quotidienne"),
          ),

          NavigationDrawerDestination(
            icon: Badge(
              label: const Text('3'),
              child: const Icon(Icons.notifications_outlined),
            ),
            selectedIcon: const Icon(Icons.notifications),
            label: const Text("Notifications"),
          ),

          const NavigationDrawerDestination(
            icon: Icon(Icons.qr_code_scanner_outlined),
            selectedIcon: Icon(Icons.qr_code_2),
            label: Text("QR Code"),
          ),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "Version 1.0.0",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}