import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class CentralStation {
  static bool _updateNeeded = true; // Proper initialization

  static const fontColor = Color(0xff595959);
  static const borderColor = Color(0xffd3d3d3);

  static void init() {
    // Ensure _updateNeeded is initialized if needed in future
    _updateNeeded = _updateNeeded;
  }

  static bool get updateNeeded {
    init(); // Ensure initialization is done
    return _updateNeeded;
  }

  static set updateNeeded(bool value) {
    _updateNeeded = value;
  }

  static String stringForDatetime(DateTime dt) {
    var dtInLocal = dt.toLocal();
    var now = DateTime.now().toLocal();
    var dateString = "Edited ";
    var diff = now.difference(dtInLocal);

    if (now.day == dtInLocal.day) {
      // Creates format like: 12:35 PM
      var todayFormat = DateFormat("h:mm a");
      dateString += todayFormat.format(dtInLocal);
    } else if (diff.inDays == 1 ||
        (diff.inSeconds < 86400 && now.day != dtInLocal.day)) {
      var yesterdayFormat = DateFormat("h:mm a");
      dateString += "Yesterday, ${yesterdayFormat.format(dtInLocal)}";
    } else if (now.year == dtInLocal.year && diff.inDays > 1) {
      var monthFormat = DateFormat("MMM d");
      dateString += monthFormat.format(dtInLocal);
    } else {
      var yearFormat = DateFormat("MMM d y");
      dateString += yearFormat.format(dtInLocal);
    }

    return dateString;
  }
}
