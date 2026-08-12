class EventModel {
  final String eventName;
  final String description;
  final String taskType;
  final String taskSubType;
  final String hrs;
  final String mns;

  EventModel({
    required this.eventName,
    required this.description,
    required this.taskType,
    required this.taskSubType,
    required this.hrs,
    required this.mns,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventName: json['event_name'] ?? '',
      description: json['description'] ?? '',
      taskType: json['task_type'] ?? '',
      taskSubType: json['task_sybtype'] ?? '',
      hrs: json['hours'].toInt().toString(),
      mns: json['minutes'].toInt().toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventname': eventName,
      'description': description,
    };
  }
}
