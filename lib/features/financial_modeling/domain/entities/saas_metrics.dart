import 'package:equatable/equatable.dart';

/// Value Object representing the Key Performance Indicators for a SaaS business
/// for a specific period (usually a month).
class SaaSMetrics extends Equatable {
  final double newMrr;
  final double expansionMrr;
  final double contractionMrr;
  final double churnMrr;
  final double totalMrr;
  final double arr;
  final int activeCustomers;
  final double churnRate;
  final double arpa;

  const SaaSMetrics({
    required this.newMrr,
    required this.expansionMrr,
    required this.contractionMrr,
    required this.churnMrr,
    required this.totalMrr,
    required this.arr,
    required this.activeCustomers,
    required this.churnRate,
    required this.arpa,
  });

  /// Factory for creating an empty/initial instance.
  factory SaaSMetrics.empty() {
    return const SaaSMetrics(
      newMrr: 0,
      expansionMrr: 0,
      contractionMrr: 0,
      churnMrr: 0,
      totalMrr: 0,
      arr: 0,
      activeCustomers: 0,
      churnRate: 0,
      arpa: 0,
    );
  }

  @override
  List<Object> get props => [
    newMrr,
    expansionMrr,
    contractionMrr,
    churnMrr,
    totalMrr,
    arr,
    activeCustomers,
    churnRate,
    arpa,
  ];

  Map<String, dynamic> toMap() {
    return {
      'newMrr': newMrr,
      'expansionMrr': expansionMrr,
      'contractionMrr': contractionMrr,
      'churnMrr': churnMrr,
      'totalMrr': totalMrr,
      'arr': arr,
      'activeCustomers': activeCustomers,
      'churnRate': churnRate,
      'arpa': arpa,
    };
  }

  factory SaaSMetrics.fromMap(Map<String, dynamic> map) {
    return SaaSMetrics(
      newMrr: map['newMrr']?.toDouble() ?? 0.0,
      expansionMrr: map['expansionMrr']?.toDouble() ?? 0.0,
      contractionMrr: map['contractionMrr']?.toDouble() ?? 0.0,
      churnMrr: map['churnMrr']?.toDouble() ?? 0.0,
      totalMrr: map['totalMrr']?.toDouble() ?? 0.0,
      arr: map['arr']?.toDouble() ?? 0.0,
      activeCustomers: map['activeCustomers'] as int? ?? 0,
      churnRate: map['churnRate']?.toDouble() ?? 0.0,
      arpa: map['arpa']?.toDouble() ?? 0.0,
    );
  }
}
