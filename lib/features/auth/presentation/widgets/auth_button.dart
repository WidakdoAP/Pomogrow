import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AuthButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppPallete.gradient1,
            AppPallete.gradient2,
            AppPallete.gradient3,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55),
          backgroundColor: AppPallete.transparentColor,
          shadowColor: Colors.transparent,
        ),
        child: Text('Sign Up', style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
