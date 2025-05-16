import 'package:flutter/material.dart';
import 'package:test_app_rev/widgets/gradient_button.dart';
import 'package:test_app_rev/widgets/login_field.dart';
import 'welcome_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isAdmin = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SingleChildScrollView( 
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          
            children: [
              Image.asset("assets/images/signin_balls.png"),

              Text(
                "Giriş yap",
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 50,),

              LoginField(
                hintText: "Kullanıcı adı",
                isPasswordField: false,
              ),

              SizedBox(height: 15,),

              LoginField(
                hintText: "Şifre",
                isPasswordField: true,
              ),

              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _isAdmin,
                    onChanged: (val) => setState(() => _isAdmin = val ?? false),
                    activeColor: colorScheme.primary,
                  ),
                  Text(
                    'Admin olarak giriş yap',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20,),

              GradientButton(onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => WelcomeScreen(isAdmin: _isAdmin,)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}