import 'package:pomogrow/features/home/data/datasources/home_datasource.dart';
import 'package:pomogrow/features/market/domain/entities/item_product.dart';

class OwnedProductModel extends ItemProduct {
  OwnedProductModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.status,
    required super.favorite,
    required super.price,
  });

  factory OwnedProductModel.fromMap(
      Map<String, dynamic> map,
      HomeDatasource datasource, {
        String status = 'needed',
        bool favorite = false
      }
      ) {
    final imagePath = map['image_path'] ?? '';
    final imageUrl = imagePath.isNotEmpty
        ? datasource.getPlantImageUrl(imagePath)
        : '';
    return OwnedProductModel(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      imageUrl: imageUrl, //map['image_url'] ?? '',
      status: status,
      favorite: favorite,
      price: int.parse(map['price'].toString()),
    );
  }
}
