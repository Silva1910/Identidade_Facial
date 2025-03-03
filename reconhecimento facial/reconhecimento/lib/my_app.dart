import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reconhecimento/pages/login_page.dart' ;



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
         textTheme: GoogleFonts.robotoTextTheme(), // Roboto como padrão
      ), 
      home: const LoginPage(),
    );
  }
}