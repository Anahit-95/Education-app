import 'package:educational_app/core/extensions/int_extensions.dart';

extension DateTimeExt on DateTime {
  String get timeAgo {
    final nowUtc = DateTime.now().toUtc();

    final differenceTime = nowUtc.difference(toUtc());

    if (differenceTime.inDays > 365) {
      final years = (differenceTime.inDays / 365).floor();
      return '$years year${years.pluralize} ago';
    } else if (differenceTime.inDays > 30) {
      final months = (differenceTime.inDays / 30).floor();
      return '$months month${months.pluralize} ago';
    } else if (differenceTime.inDays > 0) {
      return '${differenceTime.inDays} day${differenceTime.inDays.pluralize} ago';
    } else if (differenceTime.inHours > 0) {
      return '${differenceTime.inHours} hour${differenceTime.inHours.pluralize} ago';
    } else if (differenceTime.inMinutes > 0) {
      return '${differenceTime.inMinutes} minute${differenceTime.inMinutes.pluralize} ago';
    } else {
      return 'now';
    }
  }
}
