import 'package:intl/intl.dart';

getCustomFormattedDateTime(int? givenDateTime) {
  final dateFormat = DateFormat('dd-MM-yyyy hh:mm');
  return dateFormat.format(
      DateTime.fromMillisecondsSinceEpoch(givenDateTime!* 1000));
}

getFormattedDateTime(DateTime date) {
  final dateFormat = DateFormat('yyyy-MM-dd');
  return dateFormat.format(date);
}
