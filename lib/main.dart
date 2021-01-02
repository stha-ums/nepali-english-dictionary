import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dictionary_screen.dart';

void main() => runApp(MyApp());
  
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        darkTheme: ThemeData.dark().copyWith(
          accentColor: Colors.pinkAccent,
          textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
        ),
        theme: ThemeData.light().copyWith(
          accentColor: Colors.pinkAccent,
          primaryColor: Colors.pinkAccent,
          textTheme: GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme),
        ),
        debugShowCheckedModeBanner: false,
        home: DictionaryApp());
  }
}
