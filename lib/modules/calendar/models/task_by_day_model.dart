class TaskByDayModel {
  final String id;
  final DateTime date;
  final String taskType;
  final String caption;
  final String description;
  final DateTime fromDate;
  final DateTime toDate;
  final String isAllDay;

  TaskByDayModel({
    required this.id,
    required this.date,
    required this.taskType,
    required this.caption,
    required this.description,
    required this.fromDate,
    required this.toDate,
    required this.isAllDay,
  });

  factory TaskByDayModel.fromJson(Map<String, dynamic> json) {
    return TaskByDayModel(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      taskType: json['task_type'] ?? '',
      caption: json['caption'] ?? '',
      description: json['description'] ?? '',
      fromDate: DateTime.parse(json['from_date']),
      toDate: DateTime.parse(json['to_date']),
      isAllDay: json['isallday'] ?? 'No',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'task_type': taskType,
      'caption': caption,
      'description': description,
      'from_date': fromDate.toIso8601String(),
      'to_date': toDate.toIso8601String(),
      'isallday': isAllDay,
    };
  }
}
