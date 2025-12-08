import 'package:pomogrow/features/field/domain/entities/field_tile.dart';
import 'package:pomogrow/features/field/domain/repositories/field_repository.dart';

class GetFieldTiles {
  final FieldRepository repository;

  GetFieldTiles(this.repository);

  Future<List<FieldTile>> call() async {
    return await repository.getFieldTiles();
  }
}
