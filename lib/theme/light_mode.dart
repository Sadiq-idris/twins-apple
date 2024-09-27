import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

final lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    primary: const Color(0xFF98BF45),
    onPrimary: Colors.white,
    secondary: const Color(0xFFF27B35),
    tertiary: Colors.grey[200],
  ),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontSize: 40,
      fontWeight: FontWeight.w500,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 15,
    ),
    labelLarge: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: GoogleFonts.poppins(
      fontSize: 15,
      color: Colors.orangeAccent,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: 12,
      color: Colors.red,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 12,
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    labelTextStyle: WidgetStatePropertyAll(GoogleFonts.poppins(
      fontSize: 15,
    )),
  ),
);
