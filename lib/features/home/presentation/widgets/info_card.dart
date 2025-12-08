import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';
import 'package:pomogrow/features/home/presentation/providers/user_provider.dart';

class InfoCard extends ConsumerStatefulWidget {
  const InfoCard({super.key});

  @override
  ConsumerState<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends ConsumerState<InfoCard> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(userProfileProvider.notifier).refreshProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    if (profileAsync.isLoading) {
      return const CircularProgressIndicator();
    }

    final profile = profileAsync.value!;
    String limitText(String text, int maxLength) {
      if (text.length <= maxLength) return text;
      return text.substring(0, maxLength) + "...";
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: profile.avatarUrl.isNotEmpty
            ? NetworkImage(profile.avatarUrl)
            : null,
        child: profile.avatarUrl.isEmpty
            ? Icon(Icons.person, color: AppPallete.backgroundColor)
            : null,
      ),
      title: Text(
        limitText(profile.username, 13),
        style: Theme.of(context).textTheme.bodyLarge,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
