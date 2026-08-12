class TaskRowOptionModel {
  final String action;
  final String url;
  final String transid;

  TaskRowOptionModel({
    required this.action,
    required this.url,
    required this.transid,
  });

  factory TaskRowOptionModel.fromJson(Map<String, dynamic> json) {
    return TaskRowOptionModel(
      action: json['action'] ?? '',
      url: json['url'] ?? '',
      transid: json['transid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'url': url,
      'transid': transid,
    };
  }

  // static List<TaskRowOptionModel> twoOptions = [
  //   TaskRowOptionModel(action: "Accept", url: "/task/edit"),
  //   TaskRowOptionModel(action: "Close", url: "/task/delete"),
  // ];

  // static List<TaskRowOptionModel> threeOptions = [
  //   TaskRowOptionModel(action: "Accept", url: "/task/view"),
  //   TaskRowOptionModel(action: "Assign", url: "/task/share"),
  //   TaskRowOptionModel(action: "Close", url: "/task/archive"),
  // ];

  // static List<TaskRowOptionModel> fiveOptions = [
  //   TaskRowOptionModel(action: "Approve", url: "/task/approve"),
  //   TaskRowOptionModel(action: "Reject", url: "/task/reject"),
  //   TaskRowOptionModel(action: "Duplicate", url: "/task/duplicate"),
  //   TaskRowOptionModel(action: "Assign", url: "/task/assign"),
  //   TaskRowOptionModel(action: "Complete", url: "/task/complete"),
  // ];
}
