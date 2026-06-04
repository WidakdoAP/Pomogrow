class StickerEntity {
  final String id;
  final String noteId;
  final String imageUrl;

  final bool isNetwork;

  final double x;
  final double y;

  final double width;
  final double height;

  final double rotation;

  const StickerEntity({
    required this.id,
    required this.noteId,
    required this.imageUrl,
    required this.isNetwork,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.rotation,
  });

  StickerEntity copyWith({
    String? id,
    String? noteId,
    String? imageUrl,
    bool? isNetwork,
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
  }) {
    return StickerEntity(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      imageUrl: imageUrl ?? this.imageUrl,
      isNetwork: isNetwork ?? this.isNetwork,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
    );
  }
}