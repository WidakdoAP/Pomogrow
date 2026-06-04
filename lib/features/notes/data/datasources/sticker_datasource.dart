import 'dart:io';

import 'package:pomogrow/features/notes/data/models/sticker_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class StickerDatasource {
  Future<List<StickerModel>> getStickers(String noteId);
  Future<void> saveSticker(StickerModel sticker);
  Future<void> deleteStickers(String noteId);
  Future<void> deleteSticker(StickerModel sticker);
}

class StickerDatasourceImpl implements StickerDatasource {
  final SupabaseClient client;
  StickerDatasourceImpl(this.client);

  @override
  Future<List<StickerModel>> getStickers(String noteId) async {

    final response = await client
        .from('note_stickers')
        .select()
        .eq('note_id', noteId);

    return response.map<StickerModel>(
          (e) => StickerModel.fromJson(e),
    ).toList();
  }

  @override
  Future<void> deleteStickers(String noteId) async {

    // GET ALL STICKERS
    final response = await client
        .from('note_stickers')
        .select()
        .eq('note_id', noteId);

    // DELETE STORAGE FILES
    for (final item in response) {

      final imageUrl = item['image_url'];

      final uri = Uri.parse(imageUrl);

      final path =
      uri.pathSegments
          .skipWhile(
            (e) => e != 'stickers',
      )
          .skip(1)
          .join('/');

      await client.storage
          .from('stickers')
          .remove([path]);
    }

    // DELETE DB ROWS
    await client
        .from('note_stickers')
        .delete()
        .eq('note_id', noteId);
  }

  @override
  Future<void> saveSticker(StickerModel sticker) async {
    String imageUrl = sticker.imageUrl;
    if (!sticker.isNetwork) {

      final file = File(sticker.imageUrl);

      final fileName = DateTime.now()
          .millisecondsSinceEpoch
          .toString();

      await client.storage
          .from('stickers')
          .upload(fileName, file);

      imageUrl = client.storage
          .from('stickers')
          .getPublicUrl(fileName);
    }

    await client
        .from('note_stickers')
        .upsert({
      'id': sticker.id,
      'note_id': sticker.noteId,
      'image_url': imageUrl,
      'position_x': sticker.x,
      'position_y': sticker.y,
      'width': sticker.width,
      'height': sticker.height,
      'rotation': sticker.rotation,
    });
  }

  @override
  Future<void> deleteSticker(StickerModel sticker) async {
    final uri = Uri.parse(sticker.imageUrl);

    final path =
    uri.pathSegments
        .skipWhile(
          (e) => e != 'stickers',
    )
        .skip(1)
        .join('/');

    await client.storage
        .from('stickers')
        .remove([path]);

    await client
        .from('note_stickers')
        .delete()
        .eq('id', sticker.id);
  }
}