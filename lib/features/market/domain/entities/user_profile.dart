class UserProfile {
  final String id;
  int points;

  UserProfile({required this.id, required this.points});
}

class UserProduct {
  final String id;
  final String name;
  final int price;
  String status;

  UserProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.status,
  });
}
