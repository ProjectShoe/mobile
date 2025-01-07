class CustomerModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final bool isActive;

  CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.isActive,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      isActive: json['isActive'],
    );
  }
}
