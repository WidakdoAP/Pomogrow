import 'package:flutter/material.dart';

class AuthField extends StatefulWidget {
  final Widget icon;
  final String hintText;
  final bool isPassword;

  const AuthField({
    super.key,
    required this.icon,
    required this.hintText,
    this.isPassword = false,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        prefixIcon: widget.icon,
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
