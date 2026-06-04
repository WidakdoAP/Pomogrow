import 'package:pomogrow/features/field/domain/repositories/field_repository.dart';

class GetOwnedProductsCount {
  final FieldRepository repository;

  GetOwnedProductsCount(this.repository);

  Future<int> call() {
    return repository.getOwnedProductsCount();
  }
}