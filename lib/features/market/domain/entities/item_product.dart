class ItemProduct {
  final String id;
  final String name;
  final String imageUrl;
  final String status;
  final bool favorite;
  final int price;

  ItemProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.status,
    required this.favorite,
    required this.price,
  });

  // String get statusText {
  //   switch (status) {
  //     case 'needed':
  //       return '$price Poin';
  //     case 'owned_unused':
  //       return 'Terbeli';
  //     case 'in_use':
  //       return 'Digunakan';
  //     default:
  //       return '';
  //   }
  // }
}
