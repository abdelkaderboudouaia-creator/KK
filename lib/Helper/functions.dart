import 'package:get/get.dart';

/// Returns a human-readable relative time string (e.g. "2 minutes ago" /
/// "منذ دقيقتان") for the given [time].
///
/// The output language is determined by the currently active GetX locale:
/// * If the locale is **not** `ar`, English text is returned.
/// * If the locale is `ar`, Arabic text with correct dual/plural forms is
///   returned.
///
/// Used by notification and transaction cards to display timestamps.
String showTime(DateTime time) {
  DateTime now = DateTime.now();
  int secondsDifference = now.difference(time).inSeconds;

  if (Get.locale!.languageCode != 'ar') {
    if (secondsDifference >= 0 && secondsDifference <= 59) {
      return 'Now';
    } else if (secondsDifference >= 60 && secondsDifference <= 3599) {
      int minutes = secondsDifference ~/ 60;
      return '$minutes minute${minutes == 1 ? '' : 's'} ago';
    } else if (secondsDifference >= 3600 && secondsDifference <= 86399) {
      int hours = secondsDifference ~/ 3600;
      if (hours == 1) return '1 hour ago';
      return '$hours hours ago';
    } else if (secondsDifference >= 86400 && secondsDifference <= 2591999) {
      int days = secondsDifference ~/ 86400;
      if (days == 1) return '1 day ago';
      return '$days days ago';
    } else if (secondsDifference >= 2592000 && secondsDifference <= 31103999) {
      int months = secondsDifference ~/ 2592000;
      if (months == 1) return '1 month ago';
      return '$months months ago';
    } else {
      int years = secondsDifference ~/ 31104000;
      if (years == 1) return '1 year ago';
      return '$years years ago';
    }
  } else {
    if (secondsDifference >= 0 && secondsDifference <= 59) {
      return 'الآن';
    } else if (secondsDifference >= 60 && secondsDifference <= 3599) {
      int minutes = secondsDifference ~/ 60;
      if (minutes == 1) return 'دقيقة واحدة';
      if (minutes == 2) return 'دقيقتان';
      return 'منذ $minutes دقائق';
    } else if (secondsDifference >= 3600 && secondsDifference <= 86399) {
      int hours = secondsDifference ~/ 3600;
      if (hours == 1) return 'ساعة واحدة';
      if (hours == 2) return 'ساعتان';
      return 'منذ $hours ساعات';
    } else if (secondsDifference >= 86400 && secondsDifference <= 2591999) {
      int days = secondsDifference ~/ 86400;
      if (days == 1) return 'يوم واحد';
      if (days == 2) return 'يومان';
      return 'منذ $days أيام';
    } else if (secondsDifference >= 2592000 && secondsDifference <= 31103999) {
      int months = secondsDifference ~/ 2592000;
      if (months == 1) return 'شهر واحد';
      if (months == 2) return 'شهران';
      return 'منذ $months أشهر';
    } else {
      int years = secondsDifference ~/ 31104000;
      if (years == 1) return 'سنة واحدة';
      if (years == 2) return 'سنتان';
      return 'منذ $years سنوات';
    }
  }
}


String fileUrl(String path) {
  const String baseUrl = "http://192.168.179.63/qplay/public";
  return "$baseUrl/$path";
}
