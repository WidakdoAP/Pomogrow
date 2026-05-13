import 'package:pomogrow/features/market/data/datasources/banner_datasource.dart';

import '../../domain/entities/banner_promo.dart';

class BannerPromoModel extends BannerPromo {
  BannerPromoModel({
    required super.id,
    required super.imageUrl,
    required super.title,
    required super.desc,
  });

  factory BannerPromoModel.fromMap(
    Map<String, dynamic> map,
    BannerRemoteDataSource datasource,
  ) {
    final imagePath = map['image_path'] ?? '';
    final imageUrl = imagePath.isNotEmpty
        ? datasource.getBannerImageUrl(imagePath)
        : '';
    return BannerPromoModel(
      id: map['id'],
      imageUrl: imageUrl,
      title: map['title'],
      desc: map['description'],
    );
  }
}
