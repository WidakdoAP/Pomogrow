import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';

class AuthRemember extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  const AuthRemember({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          shape: const CircleBorder(),
          activeColor: AppPallete.textTitleColor,
        ),
        Text('Ingat Saya', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
