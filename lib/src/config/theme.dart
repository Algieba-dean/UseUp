import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette per UI Doc 2.1
  static const Color primaryGreen = Color(0xFF2E7D32); // Deep Forest Green
  static const Color softSage = Color(0xFFA5D6A7);     // Secondary/Backgrounds
  static const Color alertOrange = Color(0xFFE64A19);  // Expiring Soon
  static const Color neutralWhite = Color(0xFFFFFFFF);
  static const Color neutralGrey = Color(0xFFF5F5F5);  // Background grey
  static const Color textDark = Color(0xFF212121);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: softSage,
        error: alertOrange,
        background: neutralGrey,
        surface: neutralWhite,
      ),
      
      // Typography per UI Doc 2.2 (Open Sans as closest free alternative to Google Sans)
      textTheme: GoogleFonts.openSansTextTheme().copyWith(
        displayLarge: GoogleFonts.openSans(
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        titleLarge: GoogleFonts.openSans(
          fontWeight: FontWeight.w600,
          color: textDark,
          fontSize: 20,
        ),
        bodyMedium: GoogleFonts.openSans(
          color: textDark,
          fontSize: 16,
        ),
      ),

      // Card Design (Minimalist, "Apple-like")
      // cardTheme: CardTheme(
      //   elevation: 0, // Flat design
      //   color: neutralWhite,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(16), // Soft corners
      //     side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
      //   ),
      // ),
      
      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryGreen,
        foregroundColor: neutralWhite,
        elevation: 4,
      ),
    );
  }
}
