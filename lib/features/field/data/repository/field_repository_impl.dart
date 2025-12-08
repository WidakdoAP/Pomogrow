import 'package:pomogrow/features/field/data/datasources/field_remote_datasource.dart';
import 'package:pomogrow/features/field/domain/entities/field_tile.dart';
import 'package:pomogrow/features/field/domain/repositories/field_repository.dart';

class FieldRepositoryImpl implements FieldRepository {
  final FieldRemoteDatasource remoteDatasource;

  FieldRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<FieldTile>> getFieldTiles() {
    return remoteDatasource.getFieldTiles();
  }

  @override
  String getPlantImageUrl(String fileName) {
    return remoteDatasource.getPlantImageUrl(fileName);
  }
}
