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
    return Scaffold(
      appBar: AppBar( 
        title: const Text(
          'Test Uygulaması',
          style: TextStyle(
            color: Color.fromRGBO(80,100,130,1),
            fontWeight: FontWeight.bold,
            fontSize: 30,
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
              decoration: const InputDecoration(
                labelText: 'Kullanıcı Adı',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
              )
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Checkbox(
                  value: _isAdmin,
                  onChanged: (val) => setState(() => _isAdmin = val ?? false),
                  activeColor: Color.fromRGBO(80,100,130,1),
                ),
                const Text('Admin olarak giriş yap'),
              ],
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => WelcomeScreen(isAdmin: _isAdmin)),
              ),
              icon: const Icon(
                Icons.door_sliding_rounded,
                color: Colors.white,
              ),
              label: const Text("Giriş yap"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromRGBO(80,100,130,1),
              ),
            ),

          ],
        ),
      ),
    );
  }
}