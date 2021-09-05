import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: Color(0xFF5C0E51),
  accentColor: Color(0xFF13314A),
  errorColor: Color(0xFF6E0010),
  backgroundColor: Color(0xFFFFFCF5),
  textTheme: TextTheme(
    headline1: GoogleFonts.oswald().copyWith(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: Color(0xFF13314A),
    ),
    headline2: GoogleFonts.oswald().copyWith(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Color(0xFF13314A),
    ),
    headline3: GoogleFonts.oswald().copyWith(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(0xFF5C0E51),
    ),
    headline4: GoogleFonts.oswald().copyWith(
      fontSize: 18,
      // fontWeight: FontWeight.bold,
      color: Color(0xFF13314A),
    ),
    headline5: GoogleFonts.oswald().copyWith(
      fontSize: 16,
      color: Color(0xFF13314A),
    ),
    bodyText1: TextStyle(
      fontSize: 16,
    ),
  ),
);
