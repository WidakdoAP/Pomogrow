import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/features/home/data/repositories/menu_repository.dart';
import 'package:pomogrow/features/home/domain/entities/menu_item.dart';
import 'package:pomogrow/features/home/domain/repositories/menu_repo.dart';

// Repository Provider
final menuRepositoryProvider = Provider<MenuRepo>((ref) {
  return MenuRepositoryImpl();
});

// Notifier modern
class MenuNotifier extends Notifier<List<MenuItem>> {
  @override
  List<MenuItem> build() {
    final repo = ref.read(menuRepositoryProvider);
    return repo.getMenuItems();
  }
}

// Provider untuk MenuNotifier
final menuControllerProvider = NotifierProvider<MenuNotifier, List<MenuItem>>(
  () => MenuNotifier(),
);

// Active menu index
class ActiveMenuIndexNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void setIndex(int index) {
    state = index;
  }
}

class BottomBarIndexNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void setIndex(int index) {
    state = index;
  }
}

final activeMenuIndexProvider = NotifierProvider<ActiveMenuIndexNotifier, int?>(
  () => ActiveMenuIndexNotifier(),
);

final bottomBarIndexProvider = NotifierProvider<BottomBarIndexNotifier, int?>(
  () => BottomBarIndexNotifier(),
);
