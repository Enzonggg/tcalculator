import 'package:flutter/foundation.dart';

/// Holds tip screen state and notifies listeners (Controller).
class TipTimeController extends ChangeNotifier {
  String _amountInput = '';
  String _tipInput = '';
  bool _roundUp = false;

  String get amountInput => _amountInput;
  String get tipInput => _tipInput;
  bool get roundUp => _roundUp;

  void setAmountInput(String value) {
    if (_amountInput == value) return;
    _amountInput = value;
    notifyListeners();
  }

  void setTipInput(String value) {
    if (_tipInput == value) return;
    _tipInput = value;
    notifyListeners();
  }

  void setRoundUp(bool value) {
    if (_roundUp == value) return;
    _roundUp = value;
    notifyListeners();
  }

  double get amount => double.tryParse(_amountInput) ?? 0;
  double get tipPercent => double.tryParse(_tipInput) ?? 0;
}
