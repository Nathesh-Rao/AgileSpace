class LeaveHistoryModel {
  String leaveType;
  String date;
  int totalDays;
  String status;

  LeaveHistoryModel({
    required this.leaveType,
    required this.date,
    required this.totalDays,
    required this.status,
  });

  factory LeaveHistoryModel.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryModel(
      leaveType: json['leave_type'] ?? '',
      date: json['date'] ?? '',
      totalDays: json['total_days'] ?? 0,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leave_type': leaveType,
      'date': date,
      'total_days': totalDays,
      'status': status,
    };
  }

  static List<LeaveHistoryModel> tempData = [
    LeaveHistoryModel.fromJson({"leave_type": "Annual Leave", "date": "2025-08-20", "total_days": 2, "status": "Approved"}),
    LeaveHistoryModel.fromJson({"leave_type": "Sick Leave", "date": "2025-07-15", "total_days": 1, "status": "Pending"}),
    LeaveHistoryModel.fromJson({"leave_type": "Casual Leave", "date": "2025-06-10", "total_days": 3, "status": "Rejected"}),
    LeaveHistoryModel.fromJson({"leave_type": "Annual Leave", "date": "2025-05-05", "total_days": 5, "status": "Approved"}),
    LeaveHistoryModel.fromJson({"leave_type": "Sick Leave", "date": "2025-04-22", "total_days": 2, "status": "Approved"}),
    LeaveHistoryModel.fromJson({"leave_type": "Maternity Leave", "date": "2025-03-15", "total_days": 10, "status": "Approved"}),
    LeaveHistoryModel.fromJson({"leave_type": "Casual Leave", "date": "2025-02-05", "total_days": 1, "status": "Pending"}),
    LeaveHistoryModel.fromJson({"leave_type": "Annual Leave", "date": "2025-01-25", "total_days": 4, "status": "Rejected"}),
    LeaveHistoryModel.fromJson({"leave_type": "Sick Leave", "date": "2024-12-12", "total_days": 2, "status": "Approved"}),
    LeaveHistoryModel.fromJson({"leave_type": "Annual Leave", "date": "2024-11-30", "total_days": 3, "status": "Approved"}),
    LeaveHistoryModel.fromJson({"leave_type": "Casual Leave", "date": "2024-10-18", "total_days": 1, "status": "Approved"}),
    LeaveHistoryModel.fromJson({"leave_type": "Sick Leave", "date": "2024-09-10", "total_days": 2, "status": "Rejected"}),
    LeaveHistoryModel.fromJson({"leave_type": "Annual Leave", "date": "2024-08-05", "total_days": 6, "status": "Approved"}),
    LeaveHistoryModel.fromJson({"leave_type": "Paternity Leave", "date": "2024-07-15", "total_days": 7, "status": "Approved"}),
    LeaveHistoryModel.fromJson({"leave_type": "Casual Leave", "date": "2024-06-20", "total_days": 2, "status": "Pending"}),
    LeaveHistoryModel.fromJson({"leave_type": "Annual Leave", "date": "2024-05-12", "total_days": 5, "status": "Approved"}),
    LeaveHistoryModel.fromJson({"leave_type": "Sick Leave", "date": "2024-04-01", "total_days": 3, "status": "Approved"}),
    LeaveHistoryModel.fromJson({"leave_type": "Annual Leave", "date": "2024-03-25", "total_days": 4, "status": "Rejected"}),
    LeaveHistoryModel.fromJson({"leave_type": "Casual Leave", "date": "2024-02-14", "total_days": 1, "status": "Approved"}),
    LeaveHistoryModel.fromJson({"leave_type": "Annual Leave", "date": "2024-01-05", "total_days": 3, "status": "Approved"}),
  ];
}
