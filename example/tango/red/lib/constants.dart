import 'package:example/util.dart';
import 'package:flutter/material.dart';

class AppConstants implements RequiredConstants {
  ThemeData get theme => ThemeData(
        primarySwatch: Colors.red,
      );

  String get title => 'Tango Red';
}
