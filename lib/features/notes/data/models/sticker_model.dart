import 'package:pomogrow/features/notes/domain/entities/sticker_entity.dart';

class StickerModel extends StickerEntity {
  const StickerModel({
    required super.id,
    required super.noteId,
    required super.imageUrl,
    required super.isNetwork,
    required super.x,
    required super.y,
    required super.width,
    required super.height,
    required super.rotation,
  });

  factory StickerModel.fromJson(Map<String, dynamic> json) {
    return StickerModel(
      id: json['id'],
      noteId: json['note_id'],
      imageUrl: json['image_url'],
      isNetwork: true,
      x: (json['position_x'] as num).toDouble(),
      y: (json['position_y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      rotation: (json['rotation'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'note_id': noteId,
      'image_url': imageUrl,
      'position_x': x,
      'position_y': y,
    };
  }
}