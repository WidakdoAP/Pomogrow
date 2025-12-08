import 'package:pomogrow/features/field/domain/repositories/field_repository.dart';

class GetImageUrl {
  final FieldRepository repository;

  GetImageUrl(this.repository);

  String call(String? fileName) {
    if (fileName == null || fileName.isEmpty) return "";
    return repository.getPlantImageUrl(fileName);
  }
}
