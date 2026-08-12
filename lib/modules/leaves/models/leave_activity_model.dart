class LeaveActivityModel {
  String date;
  int totalLeave;
  int balanceLeave;
  List<UpcomingLeave> upcomingLeave;
  int pendingLeaveCount;

  LeaveActivityModel({
    required this.date,
    required this.totalLeave,
    required this.balanceLeave,
    required this.upcomingLeave,
    required this.pendingLeaveCount,
  });

  factory LeaveActivityModel.fromJson(Map<String, dynamic> json) {
    return LeaveActivityModel(
      date: json['date'] ?? '',
      totalLeave: json['total_leave'] ?? 0,
      balanceLeave: json['balance_leave'] ?? 0,
      upcomingLeave: (json['upcoming_leave'] as List<dynamic>?)?.map((e) => UpcomingLeave.fromJson(e)).toList() ?? [],
      pendingLeaveCount: json['pending_leave_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'total_leave': totalLeave,
      'balance_leave': balanceLeave,
      'upcoming_leave': upcomingLeave.map((e) => e.toJson()).toList(),
      'pending_leave_count': pendingLeaveCount,
    };
  }

  /// Static temp data for testing
  static LeaveActivityModel tempData = LeaveActivityModel.fromJson({
    "date": "2025-08-12",
    "total_leave": 20,
    "balance_leave": 12,
    "upcoming_leave": [
      {"date": "2025-08-20", "days_no": 2, "leave_type": "Annual Leave", "approved_by": "Manager Name"},
      {"date": "2025-09-05", "days_no": 1, "leave_type": "Sick Leave", "approved_by": "HR Department"}
    ],
    "pending_leave_count": 1
  });
}

class UpcomingLeave {
  String date;
  int daysNo;
  String leaveType;
  String approvedBy;

  UpcomingLeave({
    required this.date,
    required this.daysNo,
    required this.leaveType,
    required this.approvedBy,
  });

  factory UpcomingLeave.fromJson(Map<String, dynamic> json) {
    return UpcomingLeave(
      date: json['date'] ?? '',
      daysNo: json['days_no'] ?? 0,
      leaveType: json['leave_type'] ?? '',
      approvedBy: json['approved_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'days_no': daysNo,
      'leave_type': leaveType,
      'approved_by': approvedBy,
    };
  }
}
