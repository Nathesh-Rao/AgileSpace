class TaskOverviewModel {
  final List<TaskData> data;

  TaskOverviewModel({required this.data});

  factory TaskOverviewModel.fromJson(List<dynamic> json) {
    return TaskOverviewModel(
      data: json.map((e) => TaskData.fromJson(e)).toList(),
    );
  }
}

class TaskData {
  final int pendingTodayCount;

  TaskData({required this.pendingTodayCount});

  factory TaskData.fromJson(Map<String, dynamic> json) {
    return TaskData(
      pendingTodayCount: json['pending_today_count'] ?? 0,
    );
  }
}
