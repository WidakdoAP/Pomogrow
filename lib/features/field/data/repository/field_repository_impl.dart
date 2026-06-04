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

  @override
  Future<void> plantTree() {
    return remoteDatasource.plantTree();
  }

  @override
  Future<bool> isFieldFull() {
    return remoteDatasource.isFieldFull();
  }

  @override
  Future<void> resetField() {
    return remoteDatasource.resetField();
  }

  @override
  Future<String?> getCurrentPlantImage() {
    return remoteDatasource.getCurrentPlantImage();
  }

  @override
  Future<int> getOwnedProductsCount() {
    return remoteDatasource.getOwnedProductsCount();
  }

  @override
  Future<Map<String, int>> getFocusStats() {
    return remoteDatasource.getFocusStats();
  }

  @override
  Future<void> resetFocusStats() {
    return remoteDatasource.resetFocusStats();
  }
}
