import 'package:pomogrow/features/field/data/models/field_tile.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class FieldRemoteDatasource {
  Future<List<FieldTileModel>> getFieldTiles();
  String getPlantImageUrl(String fileName);
  Future<void> plantTree();
  Future<bool> isFieldFull();
  Future<void> resetField();
  Future<String?> getCurrentPlantImage();
  Future<int> getOwnedProductsCount();
  Future<Map<String, int>> getFocusStats();
  Future<void> resetFocusStats();
}

class FieldRemoteDataSourceImpl implements FieldRemoteDatasource {
  final SupabaseClient supabase;

  FieldRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<FieldTileModel>> getFieldTiles() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final response = await supabase
        .from('field_tiles')
        .select()
        .eq('user_id', user.id)
        .order('tile_index');

    return response
        .map<FieldTileModel>((e) => FieldTileModel.fromJson(e))
        .toList();
  }

  @override
  Future<void> resetField() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase
        .from('field_tiles')
        .update({
      'plant_image': null,
    })
        .eq('user_id', user.id);
  }

  @override
  Future<void> plantTree() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    // Ambil pohon aktif
    final plantImage = await getCurrentPlantImage();

    if (plantImage == null) return;

    // Ambil tiles user
    final tiles = await supabase
        .from('field_tiles')
        .select()
        .eq('user_id', user.id)
        .order('tile_index', ascending: true);

    Map<String, dynamic>? emptyTile;

    for (final tile in tiles) {
      if (tile['plant_image'] == null) {
        emptyTile = tile;
        break;
      }
    }

    // Kalau semua penuh
    if (emptyTile == null) {
      await resetField();
      final resetTiles = await supabase
          .from('field_tiles')
          .select()
          .eq('user_id', user.id)
          .order('tile_index', ascending: true);

      if (resetTiles.isEmpty) return;
      emptyTile = resetTiles.first;
    }

    // Tanam pohon
    await supabase
        .from('field_tiles')
        .update({
      'plant_image': plantImage,
      'updated_at': DateTime.now().toIso8601String(),
    })
        .eq('id', emptyTile['id']);
  }

  @override
  String getPlantImageUrl(String fileName) {
    return supabase.storage.from("products").getPublicUrl(fileName);
  }

  @override
  Future<String?> getCurrentPlantImage() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final result = await supabase
        .from('user_products')
        .select('item_products(image_path)')
        .eq('user_id', user.id)
        .eq('status', 'in_use')
        .maybeSingle();

    if (result == null) return null;

    return result['item_products']['image_path'];
  }

  @override
  Future<bool> isFieldFull() async {
    final user = supabase.auth.currentUser;
    if (user == null) return false;

    final result = await supabase
        .from('field_tiles')
        .select()
        .eq('user_id', user.id);

    final planted =
        result.where((tile) => tile['plant_image'] != null).length;

    return planted >= 25;
  }

  @override
  Future<int> getOwnedProductsCount() async {
    final user = supabase.auth.currentUser;

    if (user == null) return 0;

    final response = await supabase
        .from('user_products')
        .select('id')
        .eq('user_id', user.id);

    return response.length;
  }

  @override
  Future<Map<String, int>> getFocusStats() async {
    final user = supabase.auth.currentUser;

    if (user == null) return {};

    final response = await supabase
        .from('user_profiles')
        .select('focus_stats')
        .eq('id', user.id)
        .single();

    return Map<String, int>.from(
      response['focus_stats'] ?? {},
    );
  }

  @override
  Future<void> resetFocusStats() async {
    final user = supabase.auth.currentUser;

    if (user == null) return;

    await supabase
        .from('user_profiles')
        .update({
      'focus_stats': {
        "0": 0,
        "1": 0,
        "2": 0,
        "3": 0,
      }
    })
        .eq('id', user.id);
  }
}
