import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(const MedicalTestApp());
}

class MedicalTestApp extends StatelessWidget {
  const MedicalTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}