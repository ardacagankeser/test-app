import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MedicalTestApp(),
    ),
  );
}

class MedicalTestApp extends StatelessWidget {
  const MedicalTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    
    return MaterialApp(
      title: 'Test App',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(80, 100, 130, 1),
          brightness: themeNotifier.brightness,
        ),

        textTheme: GoogleFonts.robotoTextTheme()
      ),
      home: AuthScreen(),
    );
  }
}