import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'program_page.dart';
import 'pass_page.dart';
import 'quotidienne_page.dart';
import 'qrcode_page.dart';
import '../services/login_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const Color tertiaryColor = Color(0xFFD78FEE);

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _requestNotificationPermissions();
  }

  Future<void> _requestNotificationPermissions() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  final List<Widget> _pages = [
    const HomePage(),
    const ProgramPage(),
    const PassPage(),
    const QuotidiennePage(),
    const QrCodePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final User? user = snapshot.data;

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
                  icon: Icon(
                      user != null ? Icons.account_circle : Icons.account_circle_outlined,
                      color: tertiaryColor
                  ),
                  onPressed: () {
                    if (user == null) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
                    } else {
                      _showProfileDialog(context, user);
                    }
                  },
                ),
                const SizedBox(width: 8),
              ],
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
                const SizedBox(height: 30),
                Center(child: Image.asset('assets/images/logo_festival.png', height: 80)),
                const Divider(indent: 20, endIndent: 20),
                _buildDrawerOption(Icons.home_outlined, Icons.home, "Accueil", 0),
                _buildDrawerOption(Icons.calendar_month_outlined, Icons.calendar_month, "Programme", 1),
                _buildDrawerOption(Icons.confirmation_number_outlined, Icons.confirmation_number, "Achat Pass", 2),
                _buildDrawerOption(Icons.today_outlined, Icons.today, "Quotidienne", 3),
                _buildDrawerOption(Icons.qr_code_scanner_outlined, Icons.qr_code_2, "QR Code", 5),
                const Spacer(),
                if (user != null)
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text("Déconnexion", style: TextStyle(color: Colors.redAccent)),
                    onTap: () => FirebaseAuth.instance.signOut(),
                  ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text("Version 1.0.0", style: TextStyle(color: Colors.grey, fontSize: 10))),
                ),
              ],
            ),
            body: _pages[_selectedIndex],
          );
        }
    );
  }

  void _showProfileDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Mon Compte"),
        content: Text("Connecté en tant que :\n${user.email}"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Fermer")),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
            child: const Text("DÉCONNEXION", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerOption(IconData icon, IconData selectedIcon, String label, int index, {String? badge}) {
    final bool isSelected = _selectedIndex == index;
    return NavigationDrawerDestination(
      icon: badge != null
          ? Badge(label: Text(badge), backgroundColor: tertiaryColor, child: Icon(icon))
          : Icon(icon),
      selectedIcon: Icon(selectedIcon),
      label: Text(label),
    );
  }
}