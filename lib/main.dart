import 'package:flutter/material.dart';
import './theme.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const FestivalApp());
}

class FestivalApp extends StatelessWidget {
  const FestivalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FEFFS App',
      debugShowCheckedModeBanner: false,
      // Simulation du thème importé (à remplacer par ton theme.dart)
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}