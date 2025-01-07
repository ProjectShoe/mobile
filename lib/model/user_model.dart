class UserModel {
  final String id;
  final String username;
  final String email;
  final String password;
  final String phone;
  final String address;
  final bool isAdmin;
  final bool isActive;
  final String createdAt;
  final String bankCode;

  UserModel(
      {required this.username,
      required this.address,
      required this.email,
      required this.password,
      required this.phone,
      required this.isAdmin,
      required this.createdAt,
      required this.isActive,
      required this.id,
      required this.bankCode});
  factory UserModel.formJson(Map<String, dynamic> json) {
    return UserModel(
        username: json['username'],
        email: json['email'],
        password: json['password'],
        phone: json['phone'],
        isAdmin: json['isAdmin'],
        isActive: json['isActive'],
        id: json['_id'],
        createdAt: json['createdAt'],
        bankCode: json['bankCode'],
        address: json['Address']
        // address: json['Address']);
        );
  }
}
