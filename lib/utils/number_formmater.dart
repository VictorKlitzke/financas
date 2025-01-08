// import 'package:intl/intl.dart';

class Utils {
  static String formmaterNumber(double value) {
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }
}
