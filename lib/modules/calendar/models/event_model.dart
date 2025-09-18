class EventModel {
  final String eventName;
  final String description;
  final DateTime fromDate;
  final DateTime toDate;
  final String isAllDay;

  EventModel({
    required this.eventName,
    required this.description,
    required this.fromDate,
    required this.toDate,
    required this.isAllDay,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventName: json['eventname'] ?? '',
      description: json['description'] ?? '',
      fromDate: DateTime.parse(json['from_date']),
      toDate: DateTime.parse(json['to_date']),
      isAllDay: json['isallday'] ?? 'No',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventname': eventName,
      'description': description,
      'from_date': fromDate.toIso8601String(),
      'to_date': toDate.toIso8601String(),
      'isallday': isAllDay,
    };
  }
}
