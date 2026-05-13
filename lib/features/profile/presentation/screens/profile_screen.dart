import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pomogrow/core/theme/palette.dart';
import 'package:pomogrow/core/widgets/back_arrow.dart';
import 'package:pomogrow/core/widgets/global_bottombar.dart';
import 'package:pomogrow/features/market/presentation/providers/transaction_provider.dart';
import 'package:pomogrow/features/profile/presentation/providers/profile_provider.dart';
import 'package:pomogrow/features/profile/presentation/widgets/profile_button.dart';
import 'package:pomogrow/features/profile/presentation/widgets/profile_clip.dart';
import 'package:pomogrow/features/profile/presentation/widgets/profile_dialog.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final user = ref.watch(userPointsProvider);
    final profile = profileAsync.value;

    if (profile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Row(
            children: [
              SafeArea(
                top: true,
                left: true,
                child: BackButtonWidgets(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ProfileClip(
              color: AppPalette.profileBackground,
              height: 700,
            ),
          ),
          Positioned(
            bottom: 700 - 60,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppPalette.profileBackground,
                        shape: BoxShape.circle,
                      ),
                    ),

                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: ClipOval(
                        child: profile.avatarUrl.isNotEmpty
                            ? Image.network(
                                profile.avatarUrl,
                                fit: BoxFit.cover,
                              )
                            : CircleAvatar(
                                radius: 70,
                                child: Icon(
                                  Icons.person,
                                  color: AppPalette.backgroundColor,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const SizedBox(height: 200),
                // I'm using the market points provider to display the point here,
                // because I'm to lazy to create a new one aakwokaowkaoaowk.
                // Is this a good practice? NO, it isn't.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 6,
                  children: [
                    Image.asset("assets/icons/points-logo.png",
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain
                    ),
                    user.when(
                      data: (profile) => Text(
                        '${profile.points}',
                        style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppPalette.backgroundColor,
                      ),
                      ),
                      loading: () =>
                      const CircularProgressIndicator(),
                      error: (e, _) =>
                      const Text('Error'),
                    )
                  ],
                ),
                Text(
                  profile.username,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.backgroundColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  profile.email,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w100,
                    color: AppPalette.backgroundColor,
                  ),
                ),
                const SizedBox(height: 30),
                ProfileButton(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final image = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image == null) return;
                    await ref
                        .read(userProfileProvider.notifier)
                        .updateAvatar(image.path);
                  },
                  text: "Ubah Foto Profil",
                  icon: Icons.image,
                ),
                const SizedBox(height: 20),
                ProfileButton(
                  onPressed: () async {
                    final name = await showCustomUsernameDialog(context);

                    if (name != null && name.isNotEmpty) {
                      await ref
                          .read(userProfileProvider.notifier)
                          .updateUsername(name);
                    }
                  },
                  text: "Ganti Username",
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),
                ProfileButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  text: "Kembali",
                  icon: Icons.door_back_door,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(left: 0, right: 0, bottom: 0, child: GlobalBottomBar()),
        ],
      ),
    );
  }
}
