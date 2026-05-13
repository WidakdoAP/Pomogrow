import 'package:pomogrow/features/home/data/datasources/home_datasource.dart';
import 'package:pomogrow/features/home/domain/repositories/home_repo.dart';

class HomeRepositoryImpl implements HomeRepo {
  final HomeDatasource datasource;
  HomeRepositoryImpl(this.datasource);

  @override
  Future<String?> getEquippedPlantImage(String userId) {
    return datasource.getEquippedPlantImage(userId);
  }
}