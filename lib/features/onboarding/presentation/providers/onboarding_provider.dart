import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/onboarding_entity.dart';
import '../../data/onboarding_local_data.dart';

final onboardingRepositoryProvider = Provider((ref) => OnboardingLocalData());

final onboardingPagesProvider = Provider<List<OnboardingEntity>>(
  (ref) => [
    OnboardingEntity(
      image: 'assets/images/onboarding_tree.png',
      title: 'WAKTU FOKUS',
      desc:
          'Fokus bersama bibit kecilmu hingga tumbuh menjadi pohon yang indah dalam waktu yang kamu tentukan! ',
    ),
    OnboardingEntity(
      image: 'assets/images/onboarding_dead.png',
      title: 'POHON MATI',
      desc:
          'Jika kamu meninggalkan aplikasi sebelum waktu fokusmu selesai, pohon kecilmu akan layu dan mati.',
    ),
    OnboardingEntity(
      image: 'assets/images/onboarding_fields.png',
      title: 'LADANG',
      desc:
          'Selesaikan fokusmu dan dapatkan pohon di ladang. Penuhi ladangnya untuk meraih poin spesial!',
    ),
    OnboardingEntity(
      image: 'assets/images/onboarding_timer.png',
      title: 'AI JADWAL',
      desc:
          'AI akan membantumu merancang jadwal dan menyimpan hasilnya ke fitur jadwal sebagai pengingat.',
    ),
  ],
);

final currentPagesProvider = StateProvider<int>((ref) => 0);
