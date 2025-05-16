import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  final String hintText;
  final bool isPasswordField;
  
  const LoginField({
    Key? key,
    required this.hintText,
    required this.isPasswordField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 400,
      ),

      child: TextFormField(
        obscureText: isPasswordField,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(27),

          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(52, 51, 67, 1),
              width: 3
            ),
            borderRadius: BorderRadius.circular(10),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 3
            ),
            borderRadius: BorderRadius.circular(10),
          ),

          hintText: hintText,
        ),
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}