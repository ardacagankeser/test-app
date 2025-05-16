import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isAdmin = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar( 
        title: Text(
          'Test Uygulaması',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ), 
        centerTitle: true
      ),

      body: Padding( 
        padding: const EdgeInsets.all(16.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Kullanıcı Adı",
                border: OutlineInputBorder(),
              ),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),

            SizedBox(height: 16),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
              ),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),

            SizedBox(height: 16),

            Row(
              children: [
                Checkbox(
                  value: _isAdmin,
                  onChanged: (val) => setState(() => _isAdmin = val ?? false),
                  activeColor: colorScheme.primary,
                ),
                Text(
                  'Admin olarak giriş yap',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => WelcomeScreen(isAdmin: _isAdmin,)),
              ),

              icon: Icon(
                Icons.door_sliding_rounded,
                color: colorScheme.primary,
              ),

              label: Text(
                "Giriş yap",
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer,
              ),
            ),

          ],
        ),
      ),
    );
  }
}