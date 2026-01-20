import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/main_wrapper.dart';

void main() {
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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD78FEE), // Rouge festival par exemple
          brightness: Brightness.light,
        ),
        // On s'assure que l'AppBar est propre partout
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0, // Évite le changement de couleur au scroll
        ),
      ),
      home: const MainWrapper(),
    );
  }
}