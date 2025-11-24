import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';

class InfoCard extends StatelessWidget {
  final String name;
  const InfoCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.person, color: AppPallete.backgroundColor),
      ),
      title: Text("User", style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
