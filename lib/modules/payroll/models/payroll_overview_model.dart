class PayrollOverviewModel {
  int totalAmount;
  String date;
  List<PayBreakup> payBreakup;

  PayrollOverviewModel({
    required this.totalAmount,
    required this.date,
    required this.payBreakup,
  });

  factory PayrollOverviewModel.fromJson(Map<String, dynamic> json) {
    return PayrollOverviewModel(
      totalAmount: json['total_amount'] ?? 0,
      date: json['date'] ?? '',
      payBreakup: (json['payBreakup'] as List<dynamic>?)?.map((e) => PayBreakup.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_amount': totalAmount,
      'date': date,
      'payBreakup': payBreakup.map((e) => e.toJson()).toList(),
    };
  }

  static PayrollOverviewModel tempData = PayrollOverviewModel.fromJson({
    "total_amount": 80000,
    "date": "2025-08-01",
    "payBreakup": [
      {"name": "Basic Salary", "amount": 40000},
      {"name": "HRA", "amount": 20000},
      {"name": "Transport Allowance", "amount": 5000},
      {"name": "Bonus", "amount": 15000}
    ]
  });
}

class PayBreakup {
  String name;
  int amount;

  PayBreakup({
    required this.name,
    required this.amount,
  });

  factory PayBreakup.fromJson(Map<String, dynamic> json) {
    return PayBreakup(
      name: json['name'] ?? '',
      amount: json['amount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }
}
