import 'package:flutter/material.dart';
import 'package:pomogrow/features/home/domain/entities/menu_item.dart';
import 'package:pomogrow/features/home/domain/repositories/menu_repo.dart';

class MenuRepositoryImpl implements MenuRepo {
  @override
  List<MenuItem> getMenuItems() {
    return [
      MenuItem(title: "Marketplace", icon: Icons.shopping_cart),
      MenuItem(title: "Logout", icon: Icons.logout),
    ];
  }
}
