import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

extension TimestampExtension on Timestamp {
  String toFormattedString() {
    // Convert the Timestamp to a DateTime
    final dateTime = this.toDate();

    // Format the DateTime as a string
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    // You can customize the format string to match your preferred date and time format
  }

  String formattedDate() {
    DateTime timestamp = this.toDate();
    return DateFormat('dd MMM yyyy').format(timestamp);
  }
}

extension TimeExtension on String {
  String? convertToTime12() {
    DateTime dateFormat = DateTime.parse(this);
    return DateFormat.jm().format(dateFormat);
  }

  String? convertToTime24() {
    DateTime dateFormat = DateTime.parse(this);
    return DateFormat.Hm().format(dateFormat);
  }

  String? convertToDate() {
    DateTime dateFormat = DateTime.parse(this);
    return DateFormat.MMMd().format(dateFormat);
  }

  String? convertToMinute() {
    DateTime dateFormat = DateTime.parse(this);
    return DateFormat.Hm().format(dateFormat);
  }

  String? convertToFullDate() {
    DateTime dateFormat = DateTime.parse(this);
    return DateFormat.yMMMd().format(dateFormat);
  }

  String? differenceDay() {
    DateTime dateFormat = DateTime.parse(this);
    final date = Jiffy(DateTime.now()).diff(dateFormat, Units.DAY).toString();
    if (date == "0") {
      return "Today";
    }
    if (date == "1") {
      return "Yesterday";
    }
    return "$date Days ago";
  }

  String? differenceHour() {
    DateTime dateFormat = DateTime.parse(this);
    final hours = Jiffy(DateTime.now()).diff(dateFormat, Units.HOUR).toString();
    return "$hours Hours ago";
  }

  String formattedTime() {
    if (this.isEmpty) {
      return ''; // Return empty string for null or empty input
    }
    DateTime timestamp =
        DateTime.fromMillisecondsSinceEpoch(int.tryParse(this) ?? 0);
    return DateFormat('hh:mm a').format(timestamp);
  }

  String formattedDate() {
    if (this.isEmpty) {
      return ''; // Return empty string for null or empty input
    }
    DateTime timestamp =
        DateTime.fromMillisecondsSinceEpoch(int.tryParse(this) ?? 0);
    return DateFormat('dd MMM yyyy').format(timestamp);
  }
}

extension TimestampFormatting on int {
  String formattedTimestamp() {
    DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(this);
    return DateFormat('dd MMM yyyy').format(timestamp);
  }
}
