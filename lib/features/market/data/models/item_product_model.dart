import 'package:pomogrow/features/market/data/datasources/item_product_datasource.dart';
import 'package:pomogrow/features/market/domain/entities/item_product.dart';

class ItemProductModel extends ItemProduct {
  ItemProductModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.status,
    required super.favorite,
    required super.price,
  });

  factory ItemProductModel.fromMap(
    Map<String, dynamic> map,
    ItemProductDatasource datasource, {
      String status = 'needed', bool favorite = false,
  }
  ) {
    final imagePath = map['image_path'] ?? '';
    final imageUrl = imagePath.isNotEmpty
        ? datasource.getPlantImageUrl(imagePath)
        : '';
    return ItemProductModel(
      id: map['id'].toString(),
      name: map['name'] ?? '',
      imageUrl: imageUrl, //map['image_url'] ?? '',
      status: status,
      favorite: favorite,
      price: int.parse(map['price'].toString()),
    );
  }
}
