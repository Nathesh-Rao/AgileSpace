class EventModel {
  final String eventName;
  final String description;
  final String taskType;
  final String taskSubType;
  final String hrs;
  final String mns;
  final String recordType;

  EventModel({
    required this.eventName,
    required this.description,
    required this.taskType,
    required this.taskSubType,
    required this.hrs,
    required this.mns,
    required this.recordType,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventName: json['event_name'] ?? '',
      description: json['description'] ?? '',
      taskType: json['task_type'] ?? '',
      taskSubType: json['task_sybtype'] ?? '',
      hrs: (json['hours'] is num) ? json['hours'].toInt().toString() : '',
      mns: (json['minutes'] is num) ? json['minutes'].toInt().toString() : '',
      recordType: json['record_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventname': eventName,
      'description': description,
      'record_type': recordType,
    };
  }
}
