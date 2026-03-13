class Booking {
  final String bookingId;
  final String userId;
  final String chargerId;
  final DateTime? date;
  final DateTime startTime;
  final DateTime endTime;
  final double amount;
  final String status;
  final String chargerType;

  Booking(
      {required this.bookingId,
      required this.userId,
      required this.chargerId,
      this.date,
      required this.startTime,
      required this.endTime,
      required this.amount,
      required this.status,
      required this.chargerType});

  factory Booking.fromJson(Map<String, dynamic> json) {
    final dateStr = json['date'];

    final baseDate = dateStr != null
        ? DateTime.parse(dateStr)
        : DateTime.now(); // fallback (or throw error)

    return Booking(
      bookingId: json['bookingId'],
      userId: json['userId'],
      chargerId: json['chargerId'],
      date: dateStr != null ? baseDate : null,
      startTime: DateTime.parse(
        "${baseDate.toIso8601String().split('T')[0]} ${json['startTime']}",
      ),
      endTime: DateTime.parse(
        "${baseDate.toIso8601String().split('T')[0]} ${json['endTime']}",
      ),
      amount: (json['amount'] as num).toDouble(),
      status: json['status'],
      chargerType: json['chargerType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'chargerId': chargerId,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'amount': amount,
      'status': status,
      'chargerType': chargerType,
    };
  }
}
