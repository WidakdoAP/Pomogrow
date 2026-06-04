class FieldTile {
  final int tileIndex;
  final String? plantImage;
  final DateTime updatedAt;

  const FieldTile({
    required this.tileIndex,
    required this.plantImage,
    required this.updatedAt,
  });

  bool get isPlanted => plantImage != null;
}
