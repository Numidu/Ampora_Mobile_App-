import 'dart:ffi';

class Subscription {
  final String? userId;
  final String planName;
  final double monthlyFeee;
  final bool active;

  Subscription({
    required this.userId,
    required this.planName,
    required this.monthlyFeee,
    required this.active,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      userId: json['userId'],
      planName: json['planName'],
      monthlyFeee: json['monthlyFree'].toDouble(),
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'planName': planName,
      'monthlyFee': monthlyFeee,
      'active': active,
    };
  }
}
