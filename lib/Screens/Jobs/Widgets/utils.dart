import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class Utils {
  static String getDate() {

    final String date = DateTime.now().toString();
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    
    String dateToday = formatted;

    print(dateToday);

    return dateToday;
  }
}
