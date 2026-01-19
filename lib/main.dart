import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // Pour les dates en français
// On importe le wrapper qui contient le menu et l'AppBar
import 'screens/main_wrapper.dart';

void main() {
  // Initialise le formatage des dates en français avant de lancer l'app
  initializeDateFormatting('fr_FR', null).then((_) {
    runApp(const FestivalApp());
  });
}

class FestivalApp extends StatelessWidget {
  const FestivalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FEFFS App',
      debugShowCheckedModeBanner: false,

      // Utilisation du thème Material 3
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EE), // Ta couleur de base
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),

      // Point d'entrée : Le Wrapper qui gère la navigation
      home: const MainWrapper(),
    );
  }
}