import 'package:equatable/equatable.dart';

/// Value Object representing the Cash Flow Statement for a specific period.
class CashFlow extends Equatable {
  final double operatingFlow;
  final double investingFlow;
  final double financingFlow;
  final double endingBalance;

  const CashFlow({
    required this.operatingFlow,
    required this.investingFlow,
    required this.financingFlow,
    required this.endingBalance,
  });

  factory CashFlow.empty() {
    return const CashFlow(
      operatingFlow: 0,
      investingFlow: 0,
      financingFlow: 0,
      endingBalance: 0,
    );
  }

  @override
  List<Object> get props => [
    operatingFlow,
    investingFlow,
    financingFlow,
    endingBalance,
  ];

  Map<String, dynamic> toMap() {
    return {
      'operatingFlow': operatingFlow,
      'investingFlow': investingFlow,
      'financingFlow': financingFlow,
      'endingBalance': endingBalance,
    };
  }

  factory CashFlow.fromMap(Map<String, dynamic> map) {
    return CashFlow(
      operatingFlow: map['operatingFlow']?.toDouble() ?? 0.0,
      investingFlow: map['investingFlow']?.toDouble() ?? 0.0,
      financingFlow: map['financingFlow']?.toDouble() ?? 0.0,
      endingBalance: map['endingBalance']?.toDouble() ?? 0.0,
    );
  }
}
