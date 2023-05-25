import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateFormatter {
  static String formatDate(dynamic date) {
    initializeDateFormatting();
    final dateFormatted = DateTime.parse(date);
    DateFormat dateFormatter = DateFormat.yMMMMEEEEd("id");
    String formatted =  dateFormatter.format(dateFormatted);
    return formatted;
  }
}