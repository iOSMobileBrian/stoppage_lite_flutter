class TimeoutLog {
  final String id;
  final String childId;
  final DateTime dateTime;
  final int durationSeconds;

  TimeoutLog({
    required this.id,
    required this.childId,
    required this.dateTime,
    required this.durationSeconds,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'childId': childId,
        'dateTime': dateTime.toIso8601String(),
        'durationSeconds': durationSeconds,
      };

  factory TimeoutLog.fromJson(Map<String, dynamic> json) => TimeoutLog(
        id: json['id'] as String,
        childId: json['childId'] as String,
        dateTime: DateTime.parse(json['dateTime'] as String),
        durationSeconds: json['durationSeconds'] as int,
      );
}
