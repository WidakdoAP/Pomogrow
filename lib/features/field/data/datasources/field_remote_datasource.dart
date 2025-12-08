import 'package:pomogrow/features/field/data/models/field_tile.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class FieldRemoteDatasource {
  Future<List<FieldTileModel>> getFieldTiles();
  String getPlantImageUrl(String fileName);
}

class FieldRemoteDataSourceImpl implements FieldRemoteDatasource {
  final SupabaseClient supabase;

  FieldRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<FieldTileModel>> getFieldTiles() async {
    final result = await supabase
        .from('field_tiles')
        .select()
        .order('tile_index');

    return result
        .map<FieldTileModel>((row) => FieldTileModel.fromJson(row))
        .toList();
  }

  @override
  String getPlantImageUrl(String fileName) {
    return supabase.storage.from("plants").getPublicUrl(fileName);
  }
}
