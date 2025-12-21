class ChargerSession {
  final String sessionId;
  final String chargerId;
  final String sessionStatus;
  final DateTime startTime;
  final DateTime? endTime;

  ChargerSession({
    required this.sessionId,
    required this.chargerId,
    required this.sessionStatus,
    required this.startTime,
    this.endTime,
  });

  factory ChargerSession.fromJson(Map<String, dynamic> json) {
    return ChargerSession(
      sessionId: json['sessionId'],
      chargerId: json['chargerId'],
      sessionStatus: json['sessionStatus'], // ONGOING / COMPLETED / CANCELLED
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    );
  }
}
