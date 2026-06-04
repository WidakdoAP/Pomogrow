import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/onboarding_entity.dart';
import '../../data/onboarding_local_data.dart';

final onboardingRepositoryProvider = Provider((ref) => OnboardingLocalData());

final onboardingPagesProvider = Provider<List<OnboardingEntity>>(
  (ref) => [
    OnboardingEntity(
      path: 'assets/animations/plant.json',
      title: 'WAKTU FOKUS',
      desc:
          'Fokus bersama bibit kecilmu hingga tumbuh menjadi pohon yang indah dalam waktu yang kamu tentukan! ',
    ),
    OnboardingEntity(
      path: 'assets/animations/dead.json',
      title: 'POHON MATI',
      desc:
          'Jika kamu meninggalkan aplikasi sebelum waktu fokusmu selesai, pohon kecilmu akan layu dan mati.',
    ),
    OnboardingEntity(
      path: 'assets/animations/fields.json',
      title: 'LADANG',
      desc:
          'Selesaikan fokusmu dan dapatkan pohon di ladang. Penuhi ladangnya untuk meraih poin spesial!',
    ),
    OnboardingEntity(
      path: 'assets/animations/list.json',
      title: 'AI & JADWAL',
      desc:
          'AI akan membantu menyelesaikan tugasmu dan kamu bisa membuat catatan tugas.',
    ),
  ],
);

final currentPagesProvider = StateProvider<int>((ref) => 0);
