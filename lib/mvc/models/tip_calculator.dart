import 'package:intl/intl.dart';

/// Pure tip math and formatting (Model).
class TipCalculator {
  TipCalculator._();

  /// Returns a locale-aware currency string for the tip.
  static String calculateTip({
    required double amount,
    required double tipPercent,
    required bool roundUp,
  }) {
    var tip = tipPercent / 100 * amount;
    if (roundUp) {
      tip = tip.ceilToDouble();
    }
    return NumberFormat.simpleCurrency().format(tip);
  }
}
