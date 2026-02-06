import 'package:equatable/equatable.dart';

/// Value Object representing Unit Economics metrics.
class UnitEconomics extends Equatable {
  final double cac;
  final double ltv;
  final double ltvCacRatio;
  final double magicNumber;
  final double paybackPeriod;

  const UnitEconomics({
    required this.cac,
    required this.ltv,
    required this.ltvCacRatio,
    required this.magicNumber,
    required this.paybackPeriod,
  });

  factory UnitEconomics.empty() {
    return const UnitEconomics(
      cac: 0,
      ltv: 0,
      ltvCacRatio: 0,
      magicNumber: 0,
      paybackPeriod: 0,
    );
  }

  @override
  List<Object> get props => [cac, ltv, ltvCacRatio, magicNumber, paybackPeriod];

  Map<String, dynamic> toMap() {
    return {
      'cac': cac,
      'ltv': ltv,
      'ltvCacRatio': ltvCacRatio,
      'magicNumber': magicNumber,
      'paybackPeriod': paybackPeriod,
    };
  }

  factory UnitEconomics.fromMap(Map<String, dynamic> map) {
    return UnitEconomics(
      cac: map['cac']?.toDouble() ?? 0.0,
      ltv: map['ltv']?.toDouble() ?? 0.0,
      ltvCacRatio: map['ltvCacRatio']?.toDouble() ?? 0.0,
      magicNumber: map['magicNumber']?.toDouble() ?? 0.0,
      paybackPeriod: map['paybackPeriod']?.toDouble() ?? 0.0,
    );
  }
}
