class FieldTile {
  final int tileIndex;
  final String? plantImage;
  final bool value;
  final DateTime updatedAt;

  const FieldTile({
    required this.tileIndex,
    required this.plantImage,
    required this.value,
    required this.updatedAt,
  });
}
