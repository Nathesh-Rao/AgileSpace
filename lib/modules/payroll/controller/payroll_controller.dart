import 'package:axpert_space/modules/payroll/models/payroll_history_model.dart';
import 'package:get/get.dart';

import '../models/payroll_overview_model.dart';

class PayRollController extends GetxController {
  var payrollOverviewLoading = false.obs;
  var payDivisionsValue = RxList<double>();
  var payRollOverview = Rxn<PayrollOverviewModel>();
  var payrollHistoryList = RxList<PayrollHistoryModel>();
  var isAmountVisible = false.obs;
  getPayrollOverviewDetails() {
    payrollOverviewLoading.value = true;
    payRollOverview.value = PayrollOverviewModel.tempData;
    payDivisionsValue.value = calculateLeavePercentages(payRollOverview.value!.payBreakup);
    payrollOverviewLoading.value = false;
    getPayrollHistory();
  }

  getPayrollHistory() {
    payrollHistoryList.value = PayrollHistoryModel.tempData;
  }

  List<double> calculateLeavePercentages(List<PayBreakup> breakups) {
    int totalLeaves = breakups.fold(0, (sum, item) => sum + item.amount);

    if (totalLeaves <= 0) {
      throw ArgumentError("Total leaves must be greater than zero");
    }

    return breakups.map((item) {
      return (item.amount / totalLeaves) * 100;
    }).toList();
  }
}
