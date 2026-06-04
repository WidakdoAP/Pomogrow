import 'package:pomogrow/features/notes/domain/entities/sticker_entity.dart';

abstract class StickerRepository {
  Future<List<StickerEntity>> getStickers(String noteId);
  Future<void> saveSticker(StickerEntity sticker);
  Future<void> deleteStickers(String noteId);
  Future<void> deleteSticker(StickerEntity sticker);
}