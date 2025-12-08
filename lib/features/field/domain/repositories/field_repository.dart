import 'package:pomogrow/features/field/domain/entities/field_tile.dart';

abstract class FieldRepository {
  Future<List<FieldTile>> getFieldTiles();
  String getPlantImageUrl(String fileName);
}
