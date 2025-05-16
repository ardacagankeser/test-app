import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GradientButton({
    Key? key,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
          colorScheme.primaryContainer,
          colorScheme.primary,
          colorScheme.onPrimaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),

      child: ElevatedButton(
        onPressed: (){
          onPressed();
        },
      
        style: ElevatedButton.styleFrom(
          fixedSize: Size(395, 55),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
      
        child: Text(
          "Giriş yap",
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.surface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}