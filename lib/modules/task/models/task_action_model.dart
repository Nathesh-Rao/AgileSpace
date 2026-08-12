class TaskActionModel {
  final String cmd;
  final String cmdVal;
  final String showIn;
  final String parentRefresh;
  final String pName;
  final String pValue;

  TaskActionModel({
    required this.cmd,
    required this.cmdVal,
    required this.showIn,
    required this.parentRefresh,
    required this.pName,
    required this.pValue,
  });

  factory TaskActionModel.fromJson(Map<String, dynamic> json) {
    return TaskActionModel(
      cmd: json['cmd'] ?? '',
      cmdVal: json['cmdval'] ?? '',
      showIn: json['showin'] ?? '',
      parentRefresh: json['parentrefresh'] ?? '',
      pName: json['pname'] ?? '',
      pValue: json['pvalue'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cmd': cmd,
      'cmdval': cmdVal,
      'showin': showIn,
      'parentrefresh': parentRefresh,
      'pname': pName,
      'pvalue': pValue,
    };
  }
}
