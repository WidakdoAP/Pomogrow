import 'package:pomogrow/features/home/domain/repositories/home_repo.dart';

class GetPlantUsecase {
  final HomeRepo repo;
  GetPlantUsecase(this.repo);

  Future<String?> call(String userId) {
    return repo.getEquippedPlantImage(
      userId,
    );
  }
}