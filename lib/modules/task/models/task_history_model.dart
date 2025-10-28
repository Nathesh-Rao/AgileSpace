class TaskHistoryModel {
  // final String fromUser;
  // final String toUser;
  final String username;
  final String modifiedon;
  final String status;
  final String message;

  TaskHistoryModel({
    required this.username,
    // required this.toUser,
    required this.modifiedon,
    required this.status,
    required this.message,
  });

  factory TaskHistoryModel.fromJson(Map<String, dynamic> json) {
    return TaskHistoryModel(
      username: json['username'],
      // toUser: json['touser'],
      modifiedon: json['modifiedon'] ?? json["date"],
      status: json['status'] ?? json["action_took"],
      message: json['message'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'fromuser': fromUser,
      'username': username,
      'modifiedon': modifiedon,
      'action_took': status,
      'message': message,
    };
  }
}
