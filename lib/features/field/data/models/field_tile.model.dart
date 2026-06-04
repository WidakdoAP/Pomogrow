import '../../domain/entities/field_tile.dart';

class FieldTileModel extends FieldTile {
  const FieldTileModel({
    required super.tileIndex,
    required super.plantImage,
    required super.updatedAt,
  });

  factory FieldTileModel.fromJson(Map<String, dynamic> json) {
    return FieldTileModel(
      tileIndex: json['tile_index'],
      plantImage: json['plant_image'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
