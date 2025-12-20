class User {
  final String? userId;
  final String fullName;
  final String email;
  final String? phone;

  User({
    this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
    };
  }
}
