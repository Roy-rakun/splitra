import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _idrFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String format(dynamic amount) {
    if (amount == null) return 'Rp 0';
    if (amount is String) {
      return _idrFormatter.format(double.tryParse(amount) ?? 0);
    }
    return _idrFormatter.format(amount);
  }
}
