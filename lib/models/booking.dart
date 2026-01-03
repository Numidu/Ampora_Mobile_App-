class Booking {
  final String bookingId;
  final String userId;
  final String chargerId;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final double amount;
  final String status;

  Booking(
      {required this.bookingId,
      required this.userId,
      required this.chargerId,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.amount,
      required this.status});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
        bookingId: json['bookingId'],
        userId: json['userId'],
        chargerId: json['chargerId'],
        date: json['date'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        amount: (json['amount'] as num).toDouble(),
        status: json['status']);
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
      'status': status
    };
  }
}
