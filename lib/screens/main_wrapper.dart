import 'package:flutter/material.dart';
import 'home_page.dart';
import 'program_page.dart';
import 'pass_page.dart';
import 'quotidienne_page.dart';
import 'notif_page.dart';
import 'qrcode_page.dart';

const Color tertiaryColor = Color(0xFFD78FEE);

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ProgramPage(),
    const PassPage(),
    const QuotidiennePage(),
    const NotifPage(),
    const QrCodePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: tertiaryColor),
        title: Image.asset(
          'assets/images/logo_festival.png',
          height: 35,
          fit: BoxFit.contain,
          errorBuilder: (c, o, s) => const Icon(Icons.movie, color: tertiaryColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: tertiaryColor),
            tooltip: "Connexion",
            onPressed: () => print("Redirection vers AuthPage"),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.black.withOpacity(0.05), height: 1.0),
        ),
      ),

      drawer: NavigationDrawer(
        backgroundColor: Colors.white,
        selectedIndex: _selectedIndex,
        indicatorColor: tertiaryColor.withOpacity(0.2),
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
          Navigator.pop(context);
        },
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 32, 16, 20),
            child: Row(
              children: [
                SizedBox(
                  height: 140,
                  width: 140,
                  child: Image.asset(
                    'assets/images/logo_festival.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.movie_creation_outlined, size: 40, color: tertiaryColor),
                  ),
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
            child: Divider(color: Colors.black12),
          ),

          _buildDrawerOption(Icons.home_outlined, Icons.home, "Accueil", 0),
          _buildDrawerOption(Icons.calendar_month_outlined, Icons.calendar_month, "Programme", 1),
          _buildDrawerOption(Icons.confirmation_number_outlined, Icons.confirmation_number, "Achat Pass", 2),

          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(color: Colors.black12),
          ),

          _buildDrawerOption(Icons.today_outlined, Icons.today, "Quotidienne", 3),
          _buildDrawerOption(Icons.notifications_outlined, Icons.notifications, "Notifications", 4, badge: '3'),
          _buildDrawerOption(Icons.qr_code_scanner_outlined, Icons.qr_code_2, "QR Code", 5),

          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(32.0),
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

  Widget _buildDrawerOption(IconData icon, IconData selectedIcon, String label, int index, {String? badge}) {
    final bool isSelected = _selectedIndex == index;

    return NavigationDrawerDestination(
      icon: badge != null
          ? Badge(label: Text(badge), backgroundColor: tertiaryColor, child: Icon(icon, color: Colors.black54))
          : Icon(icon, color: Colors.black54),
      selectedIcon: Icon(selectedIcon, color: tertiaryColor),
      label: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? tertiaryColor : Colors.black87,
        ),
      ),
    );
  }
}