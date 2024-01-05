

import 'package:easy_localization/easy_localization.dart';

extension DateTimeExtension on DateTime {
  String get formattedDate => DateFormat('yyyy년 MM월 dd일').format(this);

  String get formattedTime => DateFormat('HH:mm').format(this);

  String get formattedDateTime => DateFormat('dd/MM/yyyy HH:mm').format(this);


  String get relativeDays {
    //해당 날짜와 오늘날짜의 차이
    final diffDays = difference(DateTime.now().onlyDate).inDays;
    //음수 양수 구분 (지난간 날인지 남은 날인지 구분)
    final isNegative = diffDays.isNegative;


    final checkCondition = (diffDays, isNegative);
    return switch (checkCondition) {
      (0, _) => _tillToday, //두번째 _의 의미 : 첫번째 값이 0이기만 하면 무조건 _tillToday 반환
      (1, _) => _tillTomorrow,
      (_, true) => _dayPassed, //2번째가 무조건 음수면
      _ => _dayLeft //위의 3가지의 경우가 아니라면
    };
  }

  DateTime get onlyDate {
    return DateTime(year, month, day);
  }

  String get _dayLeft => 'daysLeft'
      .tr(namedArgs: {"daysCount": difference(DateTime.now().onlyDate).inDays.toString()});

  String get _dayPassed => 'daysPassed'
      .tr(namedArgs: {"daysCount": difference(DateTime.now().onlyDate).inDays.abs().toString()});

  String get _tillToday => 'tillToday'.tr();

  String get _tillTomorrow => 'tillTomorrow'.tr();

}
