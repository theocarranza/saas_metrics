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
}
