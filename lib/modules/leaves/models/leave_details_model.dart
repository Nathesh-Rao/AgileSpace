class LeaveDetailsModel {
  int totalLeaves;
  String date;
  List<LeaveBreakup> leaveBreakup;

  LeaveDetailsModel({
    required this.totalLeaves,
    required this.date,
    required this.leaveBreakup,
  });

  factory LeaveDetailsModel.fromJson(Map<String, dynamic> json) {
    return LeaveDetailsModel(
      totalLeaves: json['total_leaves'] ?? 0,
      date: json['date'] ?? '',
      leaveBreakup: (json['leaveBreakup'] as List<dynamic>?)?.map((e) => LeaveBreakup.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_leaves': totalLeaves,
      'date': date,
      'leaveBreakup': leaveBreakup.map((e) => e.toJson()).toList(),
    };
  }

  /// Static temp data for testing
  static LeaveDetailsModel tempData = LeaveDetailsModel.fromJson({
    "total_leaves": 25,
    "date": "2025-08-12",
    "leaveBreakup": [
      {"name": "Annual Leave", "leave_no": 12},
      {"name": "Sick Leave", "leave_no": 5},
      {"name": "Casual Leave", "leave_no": 3},
      {"name": "Earned Leave", "leave_no": 5}
    ]
  });
}

class LeaveBreakup {
  String name;
  int leaveNo;

  LeaveBreakup({
    required this.name,
    required this.leaveNo,
  });

  factory LeaveBreakup.fromJson(Map<String, dynamic> json) {
    return LeaveBreakup(
      name: json['name'] ?? '',
      leaveNo: json['leave_no'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'leave_no': leaveNo,
    };
  }
}
