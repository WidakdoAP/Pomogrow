import 'package:pomogrow/features/field/domain/entities/field_tile.dart';

abstract class FieldRepository {
  Future<List<FieldTile>> getFieldTiles();
  String getPlantImageUrl(String fileName);
  Future<void> plantTree();
  Future<bool> isFieldFull();
  Future<void> resetField();
  Future<String?> getCurrentPlantImage();
  Future<int> getOwnedProductsCount();
  Future<Map<String, int>> getFocusStats();
  Future<void> resetFocusStats();
}
