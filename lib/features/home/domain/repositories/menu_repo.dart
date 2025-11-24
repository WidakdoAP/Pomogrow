import 'package:pomogrow/features/home/domain/entities/menu_item.dart';

abstract class MenuRepo {
  List<MenuItem> getMenuItems();
}
