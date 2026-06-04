import 'package:pomogrow/features/notes/data/datasources/sticker_datasource.dart';
import 'package:pomogrow/features/notes/data/models/sticker_model.dart';
import 'package:pomogrow/features/notes/domain/entities/sticker_entity.dart';
import 'package:pomogrow/features/notes/domain/repositories/sticker_repository.dart';

class StickerRepoImpl implements StickerRepository {
  final StickerDatasource datasource;
  StickerRepoImpl(this.datasource);

  @override
  Future<List<StickerEntity>> getStickers(String noteId) {
    return datasource.getStickers(noteId);
  }

  @override
  Future<void> deleteStickers(String noteId) {
    return datasource.deleteStickers(noteId);
  }

  @override
  Future<void> saveSticker(StickerEntity sticker) {
    return datasource.saveSticker(
      StickerModel(
        id: sticker.id,
        noteId: sticker.noteId,
        imageUrl: sticker.imageUrl,
        isNetwork: sticker.isNetwork,
        x: sticker.x,
        y: sticker.y,
        width: sticker.width,
        height: sticker.height,
        rotation: sticker.rotation,
      ),
    );
  }

  @override
  Future<void> deleteSticker(StickerEntity sticker) {
    return datasource.deleteSticker(
      StickerModel(
        id: sticker.id,
        noteId: sticker.noteId,
        imageUrl: sticker.imageUrl,
        isNetwork: sticker.isNetwork,
        x: sticker.x,
        y: sticker.y,
        width: sticker.width,
        height: sticker.height,
        rotation: sticker.rotation,
      ),
    );
  }
}