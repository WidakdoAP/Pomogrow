import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';

class AuthField extends StatefulWidget {
  final Widget icon;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const AuthField({
    super.key,
    required this.icon,
    required this.validator,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.onChanged,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.isPassword ? _obscureText : false,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        prefixIcon: widget.icon,
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        errorStyle: const TextStyle(height: 0, color: AppPallete.error),
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
