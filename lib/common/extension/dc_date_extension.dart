import 'package:intl/intl.dart';

extension DCDateExtension on DateTime {
  String formatter({
    String format = 'yyyy-MM-dd',
  }) {
    final formatter = DateFormat(format);
    return formatter.format(this);
  }

  DateTime get tomorrow {
    return afterDays(days: 1);
  }

  /// 第二天零晨
  DateTime get tomorrowZeroMorning {
    return tomorrow.zeroMorning;
  }

  /// 周一的时间
  DateTime get week {
    var time = DateTime.now(); //当前时间
    int week = time.weekday; // 今天周几：1~7
    return afterDays(days: 8 - week);
  }

  /// 周一的早晨
  DateTime get weekZeroMorning {
    return week.zeroMorning;
  }

  DateTime afterDays({int days = 1}) {
    return add(Duration(days: days));
  }

  /// 是否同一天
  bool isSameDay(DateTime secondDate) {
    return year == secondDate.year &&
        month == secondDate.month &&
        day == secondDate.day;
  }

  /// 是否同一個月份
  bool isSameMonth(DateTime secondDate) {
    return year == secondDate.year && month == secondDate.month;
  }

  /// 检查日期是否为今天
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// 检查日期是否在本周（周一至周日）
  bool get isThisWeek {
    final now = DateTime.now();
    // 将日期标准化到当天的零点，以忽略时间部分
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(year, month, day);

    // 计算本周周一的日期
    // today.weekday 返回 1 (周一) 到 7 (周日)
    final startOfWeek = today.subtract(
      Duration(days: today.weekday - 1),
    );

    // 计算本周周日的日期
    final endOfWeek = today.add(
      Duration(days: 7 - today.weekday),
    );

    // 判断待检查的日期是否在周一和周日之间（含）
    return (dateToCheck.isAfter(startOfWeek) ||
            dateToCheck.isAtSameMomentAs(startOfWeek)) &&
        (dateToCheck.isBefore(endOfWeek) ||
            dateToCheck.isAtSameMomentAs(endOfWeek));
  }

  /// 今天，排除时分秒
  DateTime get today {
    return DateTime(year, month, day);
  }

  /// 零晨(与today的计算逻辑一样)
  DateTime get zeroMorning {
    return DateTime(year, month, day);
  }

  /// 距离明天还剩下的毫秒数
  int get millisecondsTillTomorrow {
    return tomorrowZeroMorning.millisecondsSinceEpoch - millisecondsSinceEpoch;
  }

  /// 距离明天还剩下的秒数
  int get secondsTillTomorrow {
    return millisecondsTillTomorrow ~/ 1000; // 整除
  }

  /// 距离周一还剩下的毫秒数
  int get millisecondsTillWeek {
    return weekZeroMorning.millisecondsSinceEpoch - millisecondsSinceEpoch;
  }

  /// 距离周一还剩下的秒数
  int get secondsTillWeek {
    return millisecondsTillWeek ~/ 1000; // 整除
  }

  /// 当天状态
  String get dayStatus {
    if (hour <= 12) {
      return '上午';
    } else {
      return '下午';
    }
  }

  /// 转时间戳（毫秒）
  int get timestampMilliseconds {
    return millisecondsSinceEpoch;
  }

  /// 转时间戳（秒）
  int get timestampSeconds {
    return millisecondsSinceEpoch ~/ 1000; // 整除
  }
}
