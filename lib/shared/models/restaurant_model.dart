class RestaurantModel {
  final String id;
  final String name;
  final String address;
  final String phone;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
    };
  }
}