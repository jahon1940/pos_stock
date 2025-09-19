class RetailReportTotal {
  final String posName;
  final PosData posData;

  RetailReportTotal({required this.posName, required this.posData});

  factory RetailReportTotal.fromJson(Map<String, dynamic> json) {
    return RetailReportTotal(
      posName: json['pos_name'],
      posData: PosData.fromJson(json['pos_data']),
    );
  }
}

class PosData {
  final List<PaymentTypeTotal> paymentTypeTotals;
  final int paymentTypeTotalsSum;
  final List<dynamic> cashMovements;

  PosData({
    required this.paymentTypeTotals,
    required this.paymentTypeTotalsSum,
    required this.cashMovements,
  });

  factory PosData.fromJson(Map<String, dynamic> json) {
    return PosData(
      paymentTypeTotals: (json['payment_type_totals'] as List)
          .map((e) => PaymentTypeTotal.fromJson(e))
          .toList(),
      paymentTypeTotalsSum: json['payment_type_totals_sum'],
      cashMovements: json['cash_movements'] ?? [],
    );
  }
}

class PaymentTypeTotal {
  final String name;
  final int total;

  PaymentTypeTotal({required this.name, required this.total});

  factory PaymentTypeTotal.fromJson(Map<String, dynamic> json) {
    return PaymentTypeTotal(
      name: json['name'],
      total: json['total'],
    );
  }
}
