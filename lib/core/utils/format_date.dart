import 'package:intl/intl.dart';

String formatDate(DateTime date) => DateFormat(
      'EEEE, MMMM d${date.year != DateTime.now().year ? ', y' : ''}',
    ).format(date);
