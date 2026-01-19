
import 'package:flutter/material.dart';

const Color black = Color(0xFF000000);
const Color primary = Color(0xFF4E56C0);
const Color secondary = Color(0xFF9B5DE0);
const Color tertiary = Color(0xFFD78FEE);
const Color quaternary = Color(0xFFFDCFFA);

final ThemeData festivalTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: primary,
    primary: primary,
    secondary: secondary,
    tertiary: tertiary,
    background: black,
    onBackground: quaternary,
    surface: black,
    onSurface: quaternary,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: 'Tilt Warp'),
    displayMedium: TextStyle(fontFamily: 'Tilt Warp'),
    displaySmall: TextStyle(fontFamily: 'Tilt Warp'),
    headlineLarge: TextStyle(fontFamily: 'Tilt Warp'),
    headlineMedium: TextStyle(fontFamily: 'Tilt Warp'),
    headlineSmall: TextStyle(fontFamily: 'Tilt Warp'),
    titleLarge: TextStyle(fontFamily: 'Tilt Warp'),
    titleMedium: TextStyle(fontFamily: 'Tilt Warp'),
    titleSmall: TextStyle(fontFamily: 'Tilt Warp'),
    bodyLarge: TextStyle(fontFamily: 'Inter'),
    bodyMedium: TextStyle(fontFamily: 'Inter'),
    bodySmall: TextStyle(fontFamily: 'Inter'),
    labelLarge: TextStyle(fontFamily: 'Inter'),
    labelMedium: TextStyle(fontFamily: 'Inter'),
    labelSmall: TextStyle(fontFamily: 'Inter'),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  useMaterial3: true,
);
